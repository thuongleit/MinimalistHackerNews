import 'package:flutter/material.dart';

import 'story.dart';

//enum StoryType { New, Top, Best, Ask, Show, Jobs }
String getStoryTitle(StoryType type) {
  switch (type) {
    case StoryType.news:
      return "New";
    case StoryType.best:
      return "Best";
    case StoryType.top:
      return "Top";
    case StoryType.ask:
      return "Ask";
    case StoryType.show:
      return "Show";
    case StoryType.jobs:
      return "Jobs";
    default:
      return "";
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
