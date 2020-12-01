import 'package:flutter/material.dart' hide showMenu;
import 'package:flutter_html/flutter_html.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../extensions/extensions.dart';

class SingleCommentTile extends StatelessWidget {
  const SingleCommentTile({
    @required this.item,
    Key key,
    this.isCollapsed = false,
  }) : super(key: key);

  final Item item;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '• ${item.by}, ${item.score > 0 ? '${item.score} points, ' : ''} ${item.timeAgo}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    TextSpan(
                      text:
                          ' [${isCollapsed ? '+${item.kids.length + 1} more' : '-'}]',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        (!isCollapsed) ? Html(data: item.text) : Container(),
      ],
    );
  }
}
