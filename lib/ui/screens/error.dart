import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

/// Screen that is displayed when the routing system
/// throws an error (404 screen).
class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BigTip(
        title: Text(FlutterI18n.translate(context, 'screen.error.title')),
        subtitle: Text(FlutterI18n.translate(context, 'screen.error.subtitle')),
        action: Text(FlutterI18n.translate(context, 'screen.error.action')),
        actionCallback: () => Navigator.pop(context),
        child: Icon(Icons.error_outline),
      ),
    );
  }
}
