import 'dart:async';
import 'package:dio/dio.dart';

import '../utils/const.dart';
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

  static Future<Response> getStory(int id) async {
    var url = getRightUrl(Const.itemUrl, '$id');
    print('request $url');
    return Dio().get(url);
  }

  /// Retrieves cherry's changelog file from GitHub.
  static Future<Response> getChangelog() async {
    return Dio().get(Const.changelog);
  }
}
