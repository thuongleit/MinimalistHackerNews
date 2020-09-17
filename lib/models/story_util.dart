import 'package:flutter/material.dart';

import 'story.dart';

//enum StoryType { New, Top, Best, Ask, Show, Jobs }
String getStoryTitleKey(StoryType type) {
  switch (type) {
    case StoryType.news:
      return 'screen.home.tab.new';
    case StoryType.best:
      return 'screen.home.tab.best';
    case StoryType.top:
      return 'screen.home.tab.top';
    case StoryType.ask:
      return 'screen.home.tab.ask';
    case StoryType.show:
      return 'screen.home.tab.show';
    case StoryType.jobs:
      return 'screen.home.tab.jobs';
    default:
      return 'screen.home.tab.default';
  }
}

IconData getStoryIcon(StoryType type) {
  switch (type) {
    case StoryType.news:
      return Icons.new_releases;
    case StoryType.best:
      return Icons.thumb_up;
    case StoryType.top:
      return Icons.whatshot;
    case StoryType.ask:
      return Icons.question_answer;
    case StoryType.show:
      return Icons.slideshow;
    case StoryType.jobs:
      return Icons.work;
    default:
      return Icons.device_unknown;
  }
}
