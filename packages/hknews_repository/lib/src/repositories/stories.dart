import 'package:hackernews_api/hackernews_api.dart';
import 'package:hknews_database/hknews_database.dart';
import 'package:dio/dio.dart';
import '../models/item.dart';

import '../const.dart';
import '../mapping/story_and_entity_mapping.dart';
import '../../src/utils/pair.dart';
import '../../src/utils/web_analyzer.dart';

/// Repository that holds stories information of Hacker News
abstract class StoriesRepository {
  Future<List<int>> getStories(StoryType type);

  Future<Item> getStory(int storyId, {bool previewContent = false});

  Future<bool> saveStory(Item story);

  Future<bool> unsaveStory(Item story);

  Future<List<Item>> getSavedStories();

  Future<bool> updateVisited(Item story);
}

class StoriesRepositoryImpl extends StoriesRepository {
  final StoryDao _localSource;
  final HackerNewsApiClient _remoteSource;

  StoriesRepositoryImpl(
      {StoryDao localSource, HackerNewsApiClient remoteSource})
      : this._localSource = localSource ?? StoryDao(),
        this._remoteSource = remoteSource ?? HackerNewsApiClient();

  Map<int, Pair<Item, bool>> _storiesCache =
      Map(); //Map<story_id, Pair(Story, is_up_to_date)>

  @override
  Future<List<int>> getStories(StoryType type) async {
    try {
      if (type == null) {
        return const [];
      }

      // Receives the data and parse it
      final Response response = await _remoteSource.get(Request(type.url));
      print('request ${type.url}');
      return List<int>.from(response.data as List<dynamic>);
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Item> getStory(int storyId, {bool previewContent = false}) async {
    try {
      if (_storiesCache.containsKey(storyId)) {
        return _storiesCache[storyId].first;
      }
      // If there is no cache data, request the data from api
      final requestUrl = '${Const.hackerNewsBaseUrl}/item/$storyId.json';
      final Response response =
          await _remoteSource.get(Request(requestUrl));
      final story = Item.fromJson(response.data);

      if (previewContent && (story.text == null || story.text.isEmpty)) {
        final storyInfo =
            await WebAnalyzer.getInfo(story.url, multimedia: false);
        if (storyInfo != null && storyInfo is WebInfo) {
          final newCopiedStory = story.copyWith(text: storyInfo.description);
          _storiesCache[story.id] = Pair(newCopiedStory, true);

          return newCopiedStory;
        }
      }

      _storiesCache[story.id] = Pair(story, true);

      return story;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> saveStory(Item story) async {
    story.updatedAt = DateTime.now().millisecondsSinceEpoch;
    return await _localSource.insertOrReplace(story.toEntity());
  }

  @override
  Future<bool> unsaveStory(Item story) async {
    return await _localSource.deleteStory(story.id);
  }

  @override
  Future<List<Item>> getSavedStories() async {
    // Try to load the data from database
    try {
      var stories = await _localSource.getStories();
      return stories.map((storyEntity) {
        var story = storyEntity.toStory();
        _storiesCache[storyEntity.id] = Pair(story, false);
        return story;
      }).toList();
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> updateVisited(Item story) async {
    var isUpdated = await _localSource.updateVisitStory(story.id);
    if (isUpdated) {
      story.visited = true;
      _storiesCache[story.id] = Pair(story, true);
    }
    return isUpdated;
  }

  Future<List<int>> getCommentsIds(Item item) async {
    Stream<Item> stream = _lazyFetchComments(item, assignDepth: false);
    List<int> comments = [];

    await for (Item comment in stream) {
      comments.add(comment.id);
    }

    return comments;
  }

  Stream<Item> _lazyFetchComments(Item item,
      {int depth = 0, bool assignDepth = true}) async* {
    if (item.kids.isEmpty) return;

    for (int kidId in item.kids) {
      Item kid = await getStory(kidId);
      if (kid == null) continue;

      if (assignDepth) kid.depth = depth;

      yield kid;

      Stream stream = _lazyFetchComments(kid, depth: kid.depth + 1);
      await for (Item grandKid in stream) {
        yield grandKid;
      }
    }
  }

  /// Takes in an Item and fetches all of its
  /// descendant in flat, non-sorted order.
  ///
  /// This mostly exists so that I can fetch items async,
  /// put them in a cache, so that later I can retrieve them
  /// in a sorted order.
  Future<List<Item>> prefetchComments({Item item}) async {
    List<Item> result = [];
    if (item.parent != null) result.add(item);
    if (item.kids.isEmpty) return Future.value(result);

    await Future.wait(item.kids.map((kidId) async {
      Item kid = await getStory(kidId);
      if (kid != null) {
        await prefetchComments(item: kid);
      }
    }));

    return Future.value(result);
  }
}
