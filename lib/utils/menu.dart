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
      'title': 'app.menu.read_it_later',
      'route': Routes.read_it_later,
      'icon': Icons.save,
    },
  ];
}
