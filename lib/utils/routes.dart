import 'package:flutter/material.dart';

import '../ui/screens/index.dart';

/// Class that holds both route names & generate methods.
/// Used by the Flutter routing system
class Routes {
  // Static route names
  static const home = '/';
  static const about = '/about';

  /// Methods that generate all routes
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      final Map<String, dynamic> args = routeSettings.arguments;

      switch (routeSettings.name) {
        case home:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => HomeScreen(title: "abc",),
          );

        case about:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => AboutScreen(),
          );
        default:
          return errorRoute(routeSettings);
      }
    } catch (_) {
      return errorRoute(routeSettings);
    }
  }

  /// Method that calles the error screen when necessary
  static Route<dynamic> errorRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => ErrorScreen(),
    );
  }
}
