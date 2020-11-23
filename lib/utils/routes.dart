import 'package:flutter/material.dart';

import '../presentation/screens/screens.dart';

/// Class that holds both route names & generate methods.
/// Used by the Flutter routing system
class Routes {
  // Static route names
  static const home = '/';
  static const login = '/login';
  static const about = '/about';
  static const settings = '/settings';
  static const saved_stories = '/saved_stories';

  /// Methods that generate all routes
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      switch (routeSettings.name) {
        case home:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => HomeScreen(),
          );

        case login:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => LoginScreen(),
          );

        case about:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => AboutScreen(),
          );

        case settings:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => SettingsScreen(),
          );
        case saved_stories:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => SavedStoriesScreen(),
          );
        default:
          return errorRoute(routeSettings);
      }
    } catch (_) {
      return errorRoute(routeSettings);
    }
  }

  /// Method that calls the error screen when necessary
  static Route<dynamic> errorRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => ErrorScreen(),
    );
  }
}
