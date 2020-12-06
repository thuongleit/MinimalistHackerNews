import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyCustomIconSlideAction extends IconSlideAction {
  const MyCustomIconSlideAction({
    Key key,
    IconData icon,
    Widget iconWidget,
    String caption,
    Color color,
    Color foregroundColor,
    VoidCallback onTap,
    bool closeOnTap = true,
    this.onTapDown,
  }) : super(
          key: key,
          icon: icon,
          iconWidget: iconWidget,
          caption: caption,
          color: color,
          foregroundColor: foregroundColor,
          onTap: onTap,
          closeOnTap: closeOnTap,
        );

  final GestureTapDownCallback onTapDown;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        color: color,
        child: InkWell(
          onTap: !closeOnTap ? onTap : () => _handleCloseAfterTap(context),
          onTapDown: onTapDown,
          child: buildAction(context),
        ),
      ),
    );
  }

  /// Calls [onTap] if not null and closes the closest [Slidable]
  /// that encloses the given context.
  void _handleCloseAfterTap(BuildContext context) {
    onTap?.call();
    Slidable.of(context)?.close();
  }
}
