import 'package:dio/dio.dart';

import '../models/index.dart';
import '../services/index.dart';
import './index.dart';
import '../database/index.dart';

/// Repository that holds saved stories of Hacker News
class SavedStoriesRepository extends BaseRepository {
  final StoryDao localSource;
  final ApiService remoteSource;

  SavedStoriesRepository(this.localSource, this.remoteSource);

  List<int> _storyIds = [];
  Map<int, Story> _stories = Map();

  List<int> get storyIds => _storyIds;

  Map<int, Story> get stories => _stories;

  @override
  Future<void> loadData() async {
    // Try to load the data from database
    try {
      var stories = await localSource.getStories();
      stories.forEach((story) {
        _storyIds.add(story.id);
        _stories[story.id] = story;
      });

      finishLoading();
    } on Exception catch (e) {
      print(e);
      receivedError();
    }
  }

  Future<Story> getStory(int storyId) {
    return remoteSource.getStory(storyId).then((response) {
      print('get story id for - $storyId');
      var story = Story.fromJson(response.data);

      _stories[story.id] = story;
      return story;
    });
  }

  Future deleteStory(Story story) => localSource.deleteStory(story.id);
}
