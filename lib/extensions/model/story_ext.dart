import 'package:flutter/material.dart';
import 'package:hknews_repository/hknews_repository.dart';

extension StoryUrl on Story {
  // story item browsing url
  static const itemBrowsingUrl = 'https://news.ycombinator.com';

  // content of an item url
  String get contentUrl => '$itemBrowsingUrl/item?id=$id';

  // vote an item url
  String get voteUrl => '$itemBrowsingUrl/vote?id=$id&how=up';
}

// enum StoryType { news, top, best, ask, show, jobs }
extension StoryTypeTitleAndIcon on StoryType {
  String get tabBarTitle {
    switch (index) {
      case 0:
        return 'screen.home.tab.new';
      case 1:
        return 'screen.home.tab.best';
      case 2:
        return 'screen.home.tab.top';
      case 3:
        return 'screen.home.tab.ask';
      case 4:
        return 'screen.home.tab.show';
      case 5:
        return 'screen.home.tab.jobs';
      default:
        return 'screen.home.tab.default';
    }
  }

  String get tabTitle {
    switch (index) {
      case 0:
        return 'screen.home.title.new';
      case 1:
        return 'screen.home.title.best';
      case 2:
        return 'screen.home.title.top';
      case 3:
        return 'screen.home.title.ask';
      case 4:
        return 'screen.home.title.show';
      case 5:
        return 'screen.home.title.jobs';
      default:
        return 'screen.home.title.default';
    }
  }

  IconData get tabIcon {
    switch (index) {
      case 0:
        return Icons.new_releases;
      case 1:
        return Icons.thumb_up;
      case 2:
        return Icons.whatshot;
      case 3:
        return Icons.question_answer;
      case 4:
        return Icons.slideshow;
      case 5:
        return Icons.work;
      default:
        return Icons.device_unknown;
    }
  }
}