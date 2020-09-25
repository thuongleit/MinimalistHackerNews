import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../models/index.dart';
import '../services/index.dart';
import './index.dart';
import '../database/index.dart';
import '../ui/widgets/index.dart';

/// Repository that holds stories information of Hacker News
class StoriesRepository extends BaseRepository {
  final StoryDao localSource;
  final ApiService remoteSource;
  final StoryType type;

  StoriesRepository(this.localSource, this.remoteSource, this.type);

  List<int> storyIds = [];
  Map<int, Story> stories = Map();

  @override
  Future<void> loadData() async {
    // Try to load the data using [ApiService]
    try {
      if (type != null) {
        // Receives the data from local database
        final Response<List> remoteDataResponse =
            await localSource.getStories(type).then((localData) {
          this.storyIds = localData.map((story) => story.id).toList();
          print('from database $storyIds');
          localData.forEach((story) {
            this.stories[story.id] = story;
          });

          return remoteSource.getStories(type);
        });

        //final Response<List> storyIds = await ApiService.getStories(type);
        //remove possible duplicated stories
        var remoteData = remoteDataResponse.data.map((e) => e as int).toList();
        remoteData.removeWhere((e) => this.storyIds.contains(e));

        this.storyIds.addAll(remoteData);
        finishLoading();
      }
    } on Exception catch (e) {
      print(e);
      receivedError();
    }
  }

  Widget buildStoryWidget(StoryType storyType, int storyId) {
    if (this.stories[storyId] != null) {
      return StoryRow(
        key: Key(storyId.toString()),
        story: this.stories[storyId],
      );
    } else {
      return FutureBuilder(
          future: remoteSource.getStory(storyId),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              var responseData = snapshot.data as Response;
              var story = Story.fromJson(responseData.data, type: storyType);

              localSource.insertOrReplace(story);

              this.stories[story.id] = story;
              return StoryRow(
                key: Key(storyId.toString()),
                story: story,
              );
            } else if (snapshot.hasError) {
              print('error id = $storyId');
              return Container();
            } else {
              return FadeLoading();
            }
          });
    }
  }
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
