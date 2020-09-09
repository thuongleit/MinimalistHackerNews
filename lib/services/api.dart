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
      case StoryType.NEW:
        return Url.newStories;
      case StoryType.TOP:
        return Url.topStories;
      case StoryType.BEST:
        return Url.bestStories;
      case StoryType.JOB:
        return Url.jobStories;
      case StoryType.SHOW:
        return Url.showStories;
      case StoryType.ASK:
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
