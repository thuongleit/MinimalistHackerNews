import 'package:hackernews_api/hackernews_api.dart';
import 'package:hknews_database/hknews_database.dart';
import 'package:dio/dio.dart';
import 'package:hknews_repository/src/const.dart';

import '../models/story.dart';

/// Repository that holds stories information of Hacker News
abstract class StoriesRepository {
  Future<List<int>> getStoryIds(StoryType type);

  Future<Story> getStory(int storyId);
}

class StoriesRepositoryImpl extends StoriesRepository {
  final StoryDao _localSource;
  final HackerNewsApiClient _remoteSource;

  StoriesRepositoryImpl(
      {StoryDao localSource, HackerNewsApiClient remoteSource})
      : this._localSource = localSource ?? StoryDao(),
        this._remoteSource = remoteSource ?? HackerNewsApiClient();

  // List<int> _storyIds = [];
  // Map<int, Story> _stories = Map(); //Map<story_id, Story>
  //
  // List<int> get storyIds => [..._storyIds];
  //
  // Map<int, Story> get stories => {..._stories};

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

  // Future<Story> getStory(int storyId) async {
  //   return remoteSource.getStory(storyId).then((response) {
  //     print('get story id for - $storyId');
  //     var story = Story.fromJson(response.data);
  //
  //     _stories[story.id] = story;
  //     return story;
  //   });
  // }
  //
  // Future<bool> saveStory(Story story) async {
  //   _storyIds.remove(story.id);
  //   final storyToSave =
  //       story.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch);
  //   localSource.insertOrReplace(storyToSave);
  //   notifyListeners();
  // }
  //
  // Future unsaveStory(int index, Story story) async {
  //   _storyIds.insert(index, story.id);
  //   localSource.deleteStory(story.id);
  //   notifyListeners();
  // }

  @override
  Future<List<int>> getStoryIds(StoryType type) async {
    try {
      if (type == null) {
        return const [];
      }

      // Receives the data and parse it
      final Response response = await _remoteSource.perform(Request(type.url));
      return (response.data as List<dynamic>).map((id) => id as int).toList();
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Story> getStory(int storyId) async {
    // TODO: implement getStory
    throw UnimplementedError();
  }
}
