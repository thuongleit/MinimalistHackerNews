import 'package:flutter/material.dart';

extension NavigatorX on Navigator {
  static Future<T> removeSnackBarAndPush<T extends Object>(
    BuildContext context,
    Route<T> route,
  ) {
    _removeSnackBar(context);
    return Navigator.of(context).push(route);
  }

  static Future<T> removeSnackBarAndPushNamed<T extends Object>(
    BuildContext context,
    String routeName, {
    Object arguments,
  }) {
    _removeSnackBar(context);
    return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
  }

  static void _removeSnackBar(BuildContext context) {
    Scaffold.of(context)?.removeCurrentSnackBar();
  }
}
