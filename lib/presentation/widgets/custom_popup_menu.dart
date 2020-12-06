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
    @required PopupMenuEntry<T> item,
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
      items: [item],
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

enum PopupMenu {
  viewComment,
  viewUser,
  share,
  shareHKNewsArticle,
  shareRealArticle,
  vote,
  unvote,
  reply,
  refresh,
}

extension PopupMenuItemDescription on PopupMenu {
  String get description {
    if (this == PopupMenu.viewComment) {
      return 'View Comment';
    } else if (this == PopupMenu.share) {
      return 'Share';
    } else if (this == PopupMenu.shareHKNewsArticle) {
      return 'Share Hacker News link';
    } else if (this == PopupMenu.shareRealArticle) {
      return 'Share article link';
    } else if (this == PopupMenu.vote) {
      return 'Vote';
    } else if (this == PopupMenu.unvote) {
      return 'Unvote';
    } else if (this == PopupMenu.reply) {
      return 'Reply';
    } else if (this == PopupMenu.refresh) {
      return 'Refresh';
    } else {
      return '';
    }
  }
}

class ItemPopupMenuEntry extends PopupMenuEntry<PopupMenu> {
  final List<PopupMenu> items;

  ItemPopupMenuEntry({@required this.items});

  @override
  final double height = 100;

  // height doesn't matter, as long as we are not giving
  // initialValue to showMenu().
  @override
  bool represents(PopupMenu item) => items.isNotEmpty && item == items[0];

  @override
  _ItemPopupMenuEntryState createState() => _ItemPopupMenuEntryState();
}

class _ItemPopupMenuEntryState extends State<ItemPopupMenuEntry> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in widget.items)
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            child: FlatButton(
              child: Text(item.description),
              onPressed: () => _onPressed(item),
            ),
          ),
      ],
    );
  }

  void _onPressed(PopupMenu menuItem) {
    Navigator.pop<PopupMenu>(context, menuItem);
  }
}
