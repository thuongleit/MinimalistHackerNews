import 'package:dio/dio.dart';

import '../models/index.dart';
import '../services/index.dart';
import './index.dart';

/// Repository that holds stories information of Hacker News
class StoriesRepository extends BaseRepository {
  StoryType type;

  StoriesRepository(this.type);

  List<int> storyIds = [];
  Map<int, Story> stories = Map();

  @override
  Future<void> loadData() async {
    // Try to load the data using [ApiService]
    try {
      if (type != null) {
        // Receives the data and parse it
        final Response<List> storyIds = await ApiService.getStories(type);
        this.storyIds = storyIds.data.map((e) => e as int).toList();
      }

      finishLoading();
    } on Exception catch (e) {
      print(e);
      receivedError();
    }
  }
}

class NewStoriesRepository extends StoriesRepository {
  NewStoriesRepository() : super(StoryType.news);
}

class TopStoriesRepository extends StoriesRepository {
  TopStoriesRepository() : super(StoryType.top);
}

class BestStoriesRepository extends StoriesRepository {
  BestStoriesRepository() : super(StoryType.best);
}

class AskStoriesRepository extends StoriesRepository {
  AskStoriesRepository() : super(StoryType.ask);
}

class ShowStoriesRepository extends StoriesRepository {
  ShowStoriesRepository() : super(StoryType.show);
}

class JobsStoriesRepository extends StoriesRepository {
  JobsStoriesRepository() : super(StoryType.jobs);
}
