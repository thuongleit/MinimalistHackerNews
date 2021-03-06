import 'package:hackernews_api/hackernews_api.dart';
import 'package:hknews_database/hknews_database.dart';
import 'package:meta/meta.dart';

import '../mapping/model_and_entity_mapping.dart';
import '../../src/utils/pair.dart';
import '../../src/utils/web_analyzer.dart';
import '../result.dart';

/// Repository that holds stories information of Hacker News
abstract class StoriesRepository {
  Future<List<int>> getItemIds(StoryType type);

  Item getCachedItem(int itemId);

  Future<Item> getItem(
    int itemId, {
    bool requestContent = false,
    bool refresh = false,
  });

  Future<Result> save(Item item);

  Future<void> saveAsDraft(Item item);

  Future<Result> unsave(Item item);

  Future<List<Item>> getSavedItems();

  Future<Result> updateVisited(Item item);

  Stream<Item> getComments(Item parent);
}

class StoriesRepositoryImpl extends StoriesRepository {
  final StoryDao _localSource;
  final HackerNewsApiClient _apiClient;

  StoriesRepositoryImpl({
    StoryDao localSource,
    HackerNewsApiClient apiClient,
  })  : this._localSource = localSource ?? StoryDao(),
        this._apiClient = apiClient ?? HackerNewsApiClientImpl();

  Map<int, Pair<Item, bool>> _itemsCache =
      Map(); //Map<story_id, Pair(Story, is_up_to_date)>

  //FIXME: Remove this logic when introduce local database
  Set<int> _localItemIds = Set();

  @override
  Future<List<int>> getItemIds(StoryType type) async {
    if (type == null) {
      return const [];
    }

    return _apiClient.getItemIds(type);
  }

  @override
  Item getCachedItem(int itemId) => _itemsCache[itemId]?.first;

  @override
  Future<Item> getItem(
    int itemId, {
    bool requestContent = false,
    bool refresh = false,
  }) async {
    Item item = getCachedItem(itemId);

    //if item is local draft, don't request a copy from server
    if (!_isDraft(item) && (refresh || item == null)) {
      item = await _apiClient.getItem(itemId);
    }

    if (item == null) {
      return null;
    }

    if (requestContent && (item.text?.isEmpty ?? true)) {
      final content = await _getContent(url: item.url);
      item = item.copyWith(text: content);
    }

    //put local draft item into the item list to display it to user immediately
    //because Hacker News server take time (some seconds) to process request (e.g. a posted comment) and show the request in the API
    //i.e. request API doesn't show the item immediately after posting
    if (_localItemIds.isNotEmpty) {
      final localKidIds = _getKidsOfParent(
        parent: item,
        kids: _localItemIds.map((id) => _itemsCache[id].first).toList(),
      ).map((kid) => kid.id).toList();

      if (localKidIds.isNotEmpty) {
        final kids = Set<int>.from(item.kids)..addAll(localKidIds);
        item = item.copyWith(
          kids: kids.toList(),
          descendants: kids.length,
        );
      }
    }

    _itemsCache[item.id] = Pair(item, true);

    return item;
  }

  bool _isDraft(Item item) => _localItemIds.contains(item?.id);

  List<Item> _getKidsOfParent({Item parent, List<Item> kids}) {
    assert(parent != null);
    assert(kids != null);

    return kids
        .map((item) {
          if (item.parent == parent.id) {
            return item;
          }
        })
        .where((item) => item != null)
        .toList();
  }

  @override
  Future<Result> save(Item item) async {
    final copiedStory =
        item.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch);
    final success = await _localSource.insertOrReplace(copiedStory.toEntity());
    return (success) ? Result.success() : Result.failure();
  }

  @override
  Future<void> saveAsDraft(Item item) {
    _localItemIds.add(item.id);
    _itemsCache[item.id] = Pair(item, true);
    return null;
  }

  @override
  Future<Result> unsave(Item item) async {
    final success = await _localSource.deleteStory(item.id);
    return (success) ? Result.success() : Result.failure();
  }

  @override
  Future<List<Item>> getSavedItems() async {
    // Try to load the data from database
    try {
      final itemsInDb = await _localSource.getItems();
      return await Future.wait(
        itemsInDb.map((element) async {
          // final itemModel = itemEntity.toModel();
          final latestItem = await _apiClient.getItem(element.id);
          _itemsCache[latestItem.id] = Pair(latestItem, true);
          return latestItem;
        }).toList(),
      );
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Result> updateVisited(Item item) async {
    var isUpdated = await _localSource.updateVisitStory(item.id);
    if (isUpdated) {
      final copiedItem = item.copyWith(visited: true);
      _itemsCache[copiedItem.id] = Pair(copiedItem, true);
    }
    return (isUpdated) ? Result.success() : Result.failure();
  }

  @override
  Stream<Item> getComments(Item parent) async* {
    if (parent.kids.isEmpty) return;

    for (int kidId in parent.kids) {
      Item kid = await getItem(kidId);
      if (kid == null) continue;

      final copiedKid = kid.copyWith(depth: parent.depth + 1);
      _itemsCache[copiedKid.id] = Pair(copiedKid, true);
      //remove draft item if there is a version from server
      if (!_isDraft(copiedKid)) {
        _localItemIds.removeWhere((draftKidId) {
          final draftItem = _itemsCache[draftKidId]?.first;

          if (draftItem != null) {
            if (draftItem.by == copiedKid.by &&
                draftItem.text == copiedKid.text) {
              _itemsCache[draftKidId] = null;
              print('removed $kidId');
              return true;
            }
          }
          return false;
        });
      }
      yield copiedKid;
    }
  }

  Future<String> _getContent({@required String url}) async {
    if (url?.isEmpty == true) {
      return '';
    }
    final info = await WebAnalyzer.getInfo(url, multimedia: false);
    if (info != null && info is WebInfo) {
      return info.description;
    }
    return '';
  }
}
