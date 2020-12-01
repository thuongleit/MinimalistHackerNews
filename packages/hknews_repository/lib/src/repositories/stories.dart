import 'package:hackernews_api/hackernews_api.dart';
import 'package:hknews_database/hknews_database.dart';

import '../mapping/model_and_entity_mapping.dart';
import '../../src/utils/pair.dart';
import '../../src/utils/web_analyzer.dart';
import '../result.dart';

/// Repository that holds stories information of Hacker News
abstract class StoriesRepository {
  Future<List<int>> getItemIds(StoryType type);

  Future<Item> getItem(int itemId, {bool previewContent = false});

  Future<Result> saveStory(Item item);

  Future<Result> unsaveStory(Item item);

  Future<List<Item>> getSavedStories();

  Future<Result> updateVisited(Item story);

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

  @override
  Future<List<int>> getItemIds(StoryType type) async {
    if (type == null) {
      return const [];
    }

    return _apiClient.getItemIds(type);
  }

  @override
  Future<Item> getItem(int storyId, {bool previewContent = false}) async {
    try {
      if (_itemsCache.containsKey(storyId)) {
        return _itemsCache[storyId].first;
      }
      final item = await _apiClient.getItem(storyId);

      if (previewContent && (item.text == null || item.text.isEmpty)) {
        final storyInfo =
            await WebAnalyzer.getInfo(item.url, multimedia: false);
        if (storyInfo != null && storyInfo is WebInfo) {
          final newCopiedStory = item.copyWith(text: storyInfo.description);
          _itemsCache[item.id] = Pair(newCopiedStory, true);

          return newCopiedStory;
        }
      }

      _itemsCache[item.id] = Pair(item, true);

      return item;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Result> saveStory(Item story) async {
    story.updatedAt = DateTime.now().millisecondsSinceEpoch;
    final success = await _localSource.insertOrReplace(story.toEntity());
    return (success)
        ? Result.success(message: 'Story saved')
        : Result.failure(message: 'Save story failed');
  }

  @override
  Future<Result> unsaveStory(Item story) async {
    final success = await _localSource.deleteStory(story.id);
    return (success)
        ? Result.success(message: 'Story unsaved')
        : Result.failure(message: 'Unsave story failed');
  }

  @override
  Future<List<Item>> getSavedStories() async {
    // Try to load the data from database
    try {
      var stories = await _localSource.getItems();
      return stories.map((storyEntity) {
        var story = storyEntity.toModel();
        _itemsCache[storyEntity.id] = Pair(story, false);
        return story;
      }).toList();
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Result> updateVisited(Item story) async {
    var isUpdated = await _localSource.updateVisitStory(story.id);
    if (isUpdated) {
      story.visited = true;
      _itemsCache[story.id] = Pair(story, true);
    }
    return (isUpdated) ? Result.success() : Result.failure();
  }

  @override
  Stream<Item> getComments(Item parent) async* {
    if (parent.kids.isEmpty) return;

    for (int kidId in parent.kids) {
      Item kid = await getItem(kidId);
      if (kid == null) continue;

      kid.depth = parent.depth + 1;

      yield kid;
    }
  }
}
