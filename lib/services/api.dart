import 'dart:async';
import 'package:dio/dio.dart';

import '../utils/url.dart';
import '../models/index.dart';

/// Serves data to several data repositories.
///
/// Makes http calls to several services, including
/// the open source r/HackerNews REST API.
class ApiService {
  static Future<Response<List>> getStories(StoryType type) async {
    var url = _getStoryUrl(type);
    print('request $url');
    return Dio().get(url);
  }

  static String _getStoryUrl(StoryType type) {
    switch (type) {
      case StoryType.news:
        return Url.newStories;
      case StoryType.top:
        return Url.topStories;
      case StoryType.best:
        return Url.bestStories;
      case StoryType.jobs:
        return Url.jobStories;
      case StoryType.show:
        return Url.showStories;
      case StoryType.ask:
        return Url.askStories;
      default:
        return '';
    }
  }

  static Future<Response> getStory(int id) async {
    var url = getRightUrl(Url.itemUrl, '$id');
    print('request $url');
    return Dio().get(url);
  }

  /// Retrieves cherry's changelog file from GitHub.
  static Future<Response> getChangelog() async {
    return Dio().get(Url.changelog);
  }
}
