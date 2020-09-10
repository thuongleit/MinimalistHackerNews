import 'package:flutter/material.dart';

import 'story.dart';

//enum StoryType { New, Top, Best, Ask, Show, Jobs }
String getStoryTitle(StoryType type) {
  switch (type) {
    case StoryType.New:
      return "New";
    case StoryType.Best:
      return "Best";
    case StoryType.Top:
      return "Top";
    case StoryType.Ask:
      return "Ask";
    case StoryType.Show:
      return "Show";
    case StoryType.Jobs:
      return "Jobs";
    default:
      return "";
  }
}

IconData getStoryIcon(StoryType type) {
  switch (type) {
    case StoryType.New:
      return Icons.new_releases;
    case StoryType.Best:
      return Icons.thumb_up;
    case StoryType.Top:
      return Icons.whatshot;
    case StoryType.Ask:
      return Icons.question_answer;
    case StoryType.Show:
      return Icons.slideshow;
    case StoryType.Jobs:
      return Icons.work;
    default:
      return Icons.device_unknown;
  }
}
