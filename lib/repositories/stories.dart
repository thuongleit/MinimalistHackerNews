import 'package:dio/dio.dart';

import '../models/index.dart';
import '../services/index.dart';
import './index.dart';
import '../database/index.dart';

/// Repository that holds stories information of Hacker News
class StoriesRepository extends BaseRepository {
  final StoryDao localSource;
  final ApiService remoteSource;
  final StoryType type;

  StoriesRepository(this.localSource, this.remoteSource, this.type);

  List<int> _storyIds = [];
  Map<int, Story> _stories = Map(); //Map<story_id, Story>

  List<int> get storyIds => _storyIds;

  Map<int, Story> get stories => _stories;

  @override
  Future<void> loadData() async {
    // Try to load the data using [ApiService]
    try {
      if (type != null) {
        // Receives the data and parse it
        final Response<List> storyIds = await remoteSource.getStories(type);
        _storyIds = storyIds.data.map((e) => e as int).toList();
      }

      finishLoading();
    } on Exception catch (e) {
      print(e);
      receivedError();
    }
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
  }

  Future<Story> getStory(int storyId) async {
    return remoteSource.getStory(storyId).then((response) {
      print('get story id for - $storyId');
      var story = Story.fromJson(response.data);

      _stories[story.id] = story;
      return story;
    });
  }

  Future saveStory(Story story) async => localSource.insertOrReplace(story);
}

class NewStoriesRepository extends StoriesRepository {
  NewStoriesRepository(StoryDao local, ApiService remote)
      : super(local, remote, StoryType.news);
}

class TopStoriesRepository extends StoriesRepository {
  TopStoriesRepository(StoryDao local, ApiService remote)
      : super(local, remote, StoryType.top);
}

class BestStoriesRepository extends StoriesRepository {
  BestStoriesRepository(StoryDao local, ApiService remote)
      : super(local, remote, StoryType.best);
}

class AskStoriesRepository extends StoriesRepository {
  AskStoriesRepository(StoryDao local, ApiService remote)
      : super(local, remote, StoryType.ask);
}

class ShowStoriesRepository extends StoriesRepository {
  ShowStoriesRepository(StoryDao local, ApiService remote)
      : super(local, remote, StoryType.show);
}

class JobsStoriesRepository extends StoriesRepository {
  JobsStoriesRepository(StoryDao local, ApiService remote)
      : super(local, remote, StoryType.jobs);
}
