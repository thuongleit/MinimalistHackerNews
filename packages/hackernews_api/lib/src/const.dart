import 'models/item.dart';

class Const {
  //Base Hacker News URL
  static const hackerNewsApiEndpoint = 'https://hacker-news.firebaseio.com/v0';
  static const hackerNewsStoryBaseUrl = "https://news.ycombinator.com";

  //stories urls
  static const newStories = '$hackerNewsApiEndpoint/newstories.json';
  static const topStories = '$hackerNewsApiEndpoint/topstories.json';
  static const bestStories = '$hackerNewsApiEndpoint/beststories.json';
  static const jobStories = '$hackerNewsApiEndpoint/jobstories.json';
  static const showStories = '$hackerNewsApiEndpoint/showstories.json';
  static const askStories = '$hackerNewsApiEndpoint/askstories.json';
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
      default:
        return '';
    }
  }
}
