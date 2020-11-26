// Adapted from https://stackoverflow.com/questions/54300081/flutter-popupmenu-on-long-press
import 'package:flutter/material.dart' hide showMenu;
import 'package:flutter/material.dart' as material show showMenu;

/// A mixin to provide convenience methods to record a tap position and show a popup menu.
mixin CustomPopupMenu<T extends StatefulWidget> on State<T> {
  Offset _tapPosition;

  /// Pass this method to an onTapDown parameter to record the tap position.
  void storePosition(TapDownDetails details) =>
      _tapPosition = details.globalPosition;

  /// Use this method to show the menu.
  Future<T> showMenu<T>({
    @required BuildContext context,
    @required List<PopupMenuEntry<T>> items,
    T initialValue,
    double elevation,
    String semanticLabel,
    ShapeBorder shape,
    Color color,
    bool captureInheritedThemes = true,
    bool useRootNavigator = false,
  }) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    return material.showMenu<T>(
      context: context,
      position: RelativeRect.fromLTRB(
        _tapPosition.dx,
        _tapPosition.dy,
        overlay.size.width - _tapPosition.dx,
        overlay.size.height - _tapPosition.dy,
      ),
      items: items,
      initialValue: initialValue,
      elevation: elevation,
      semanticLabel: semanticLabel,
      shape: shape,
      color: color,
      captureInheritedThemes: captureInheritedThemes,
      useRootNavigator: useRootNavigator,
    );
  }
}

class PlusMinusEntry extends PopupMenuEntry<int> {
  @override
  double height = 100;

  // height doesn't matter, as long as we are not giving
  // initialValue to showMenu().
  @override
  bool represents(int n) => n == 1 || n == -1;

  @override
  _PlusMinusEntryState createState() => _PlusMinusEntryState();
}

class _PlusMinusEntryState extends State<PlusMinusEntry> {
  void _onPressed(int position) {
    Navigator.pop<int>(context, position);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(onPressed: () => _onPressed(0), child: Text('View Comment')),
        FlatButton(onPressed: () => _onPressed(1), child: Text('View user')),
        FlatButton(onPressed: () => _onPressed(2), child: Text('Share')),
      ],
    );
  }
}
