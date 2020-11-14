import 'package:hknews_repository/hknews_repository.dart';
import 'package:hknews_repository/src/models/story.dart';

/// Has all urls used in the app as static const strings.
class Const {
  //Base Hacker News URL
  static const String hackerNewsBaseUrl =
      'https://hacker-news.firebaseio.com/v0';

  //stories urls
  static const newStories = '$hackerNewsBaseUrl/newstories.json';
  static const topStories = '$hackerNewsBaseUrl/topstories.json';
  static const bestStories = '$hackerNewsBaseUrl/beststories.json';
  static const jobStories = '$hackerNewsBaseUrl/jobstories.json';
  static const showStories = '$hackerNewsBaseUrl/showstories.json';
  static const askStories = '$hackerNewsBaseUrl/askstories.json';
}

extension StoryTypeUrl on StoryType {
  String get url {
    final type =
        StoryType.values.firstWhere((element) => element.index == index);

    switch (type) {
      case StoryType.news:
        return Const.newStories;
      case StoryType.top:
        return Const.topStories;
      case StoryType.best:
        return Const.bestStories;
      case StoryType.jobs:
        return Const.jobStories;
      case StoryType.show:
        return Const.showStories;
      case StoryType.ask:
        return Const.askStories;
    }
  }
}
