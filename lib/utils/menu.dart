import 'package:flutter/material.dart' hide showMenu;

import 'routes.dart';
import '../presentation/widgets/custom_popup_menu.dart';

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
  static const story_popup_menu = <PopupMenu>[
    PopupMenu.viewComment,
    PopupMenu.vote,
    PopupMenu.share,
  ];

  static const comment_popup_menu = <PopupMenu>[
    PopupMenu.reply,
    PopupMenu.vote,
    PopupMenu.share,
  ];

  static const share_popup_menu = <PopupMenu>[
    PopupMenu.shareRealArticle,
    PopupMenu.shareHKNewsArticle,
  ];
}
