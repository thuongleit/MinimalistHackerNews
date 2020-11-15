import 'package:hackernews_api/hackernews_api.dart';
import 'package:hknews_database/hknews_database.dart';
import 'package:dio/dio.dart';

import '../models/story.dart';
import '../const.dart';
import '../mapping/story_and_entity_mapping.dart';
import '../../src/utils/pair.dart';

/// Repository that holds stories information of Hacker News
abstract class StoriesRepository {
  Future<List<int>> getStoryIds(StoryType type);

  Future<Story> getStory(int storyId);

  Future<bool> saveStory(Story story);

  Future<bool> unsaveStory(Story story);

  Future<List<Story>> getSavedStories();

  Future<bool> updateVisited(Story story);
}

class StoriesRepositoryImpl extends StoriesRepository {
  final StoryDao _localSource;
  final HackerNewsApiClient _remoteSource;

  StoriesRepositoryImpl(
      {StoryDao localSource, HackerNewsApiClient remoteSource})
      : this._localSource = localSource ?? StoryDao(),
        this._remoteSource = remoteSource ?? HackerNewsApiClient();

  Map<int, Pair<Story, bool>> _stories =
      Map(); //Map<story_id, Pair(Story, is_up_to_date)>

  @override
  Future<List<int>> getStoryIds(StoryType type) async {
    try {
      if (type == null) {
        return const [];
      }

      // Receives the data and parse it
      final Response response = await _remoteSource.perform(Request(type.url));
      print('request ${type.url}');
      // // Try to load the data using [ApiService]
      // try {
      //   if (type != null) {
      //     // Receives the data from local source (database)
      //     final Response<List> remoteDataResponse =
      //         await localSource.getStories(type).then((localData) {
      //       _storyIds = localData.map((story) => story.id).toList();
      //       localData.forEach((story) {
      //         _stories[story.id] = story;
      //       });
      //
      //       finishLoading();
      //       //then load data from remote source
      //       return remoteSource.getStories(type);
      //     });
      //
      //     //remove possible duplicated stories
      //     var remoteData = remoteDataResponse.data.map((e) => e as int).toList();
      //     remoteData.removeWhere((e) => _storyIds.contains(e));
      //
      //     print('get new remote $remoteData');
      //     _storyIds.addAll(remoteData);
      //     notifyListeners();
      //   }
      // } on Exception catch (e) {
      //   print(e);
      //   receivedError(error: e);
      // }
      final storyIds =
          (response.data as List<dynamic>).map((id) => id as int).toList();

      return storyIds;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Story> getStory(int storyId) async {
    try {
      if (_stories[storyId] != null) {
        return _stories[storyId].first;
      }
      // If there is no cache data, request the data from api
      final requestUrl = '${Const.hackerNewsBaseUrl}/item/$storyId.json';
      final Response response =
          await _remoteSource.perform(Request(requestUrl));
      final story = Story.fromJson(response.data);
      _stories[story.id] = Pair(story, false);

      return story;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> saveStory(Story story) async {
    final storyToSave =
        story.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch);
    return await _localSource.insertOrReplace(storyToSave.toEntity());
  }

  @override
  Future<bool> unsaveStory(Story story) async {
    return await _localSource.deleteStory(story.id);
  }

  @override
  Future<List<Story>> getSavedStories() async {
    // Try to load the data from database
    try {
      var stories = await _localSource.getStories();
      return stories.map((storyEntity) {
        var story = storyEntity.toStory();
        _stories[storyEntity.id] = Pair(story, false);
        return story;
      }).toList();
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> updateVisited(Story story) async {
    var isUpdated = await _localSource.updateVisitStory(story.id);
    if (isUpdated) {
      var copyStory = story.copyWith(visited: true);
      _stories[story.id] = Pair(copyStory, true);
    }
    return isUpdated;
  }
}
