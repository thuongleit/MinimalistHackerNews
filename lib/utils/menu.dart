import 'package:flutter/material.dart';

import 'routes.dart';

/// Contains all possible popup menus' strings
class Menu {
  static const home = {
    'app.menu.about': Routes.about,
    'app.menu.settings': Routes.settings,
  };

  static const home_actions = [
    {
      'title': 'app.menu.saved_stories',
      'route': Routes.saved_stories,
      'icon': Icons.save,
    },
  ];
}
