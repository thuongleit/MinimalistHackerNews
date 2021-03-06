import 'package:flutter/material.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:html/parser.dart' as htmlparser;

import '../../utils/url_util.dart';

extension ItemX on Item {
  // story item browsing url
  static const itemBrowsingUrl = 'https://news.ycombinator.com';

  // content of an item url
  String get hackerNewsUrl => '$itemBrowsingUrl/item?id=$id';

  String get timeAgo {
    DateTime date = DateTime.fromMillisecondsSinceEpoch((time ?? 0) * 1000);
    return '${timeago.format(date)}';
  }

  String get textAsHtml =>
      (text != null) ? htmlparser.parse(text).body.text : '';

  String get description1 {
    final domain =
        (url?.isNotEmpty ?? false) ? UrlUtils.getBaseDomain(url) : '';
    final authorAndDomain = ('$by$domain'.length > 30 || domain.isEmpty)
        ? 'by $by'
        : 'by $by ($domain)';
    return "$authorAndDomain ${descendants > 0 ? ' | $_commentDescription' : ''}";
  }

  String get description2 {
    return '$by, $timeAgo, $_commentDescription';
  }

  String get _commentDescription {
    if (descendants > 1) {
      return '$descendants comments';
    } else if (descendants == 1) {
      return '$descendants comment';
    }
    return '';
  }
}

// enum StoryType { news, top, best, ask, show, jobs }
extension StoryTypeX on StoryType {
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
