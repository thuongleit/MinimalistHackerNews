import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:hknews_repository/hknews_repository.dart';

import '../../extensions/extensions.dart';

class CommentTile extends StatelessWidget {
  const CommentTile(
    this.item, {
    Key key,
    this.isCollapsed = false,
  }) : super(key: key);

  final Item item;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          top: 0,
          left: 0,
          right: 0,
          child: Row(
            children: List.generate(item.depth, (i) => i)
                .map((d) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(width: 2),
                    ))
                .toList(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 12.0 * item.depth,
            right: 16,
            bottom: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: " ${String.fromCharCode(8226)} ",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              TextSpan(
                                text: item.timeAgo,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  if (isCollapsed && item.kids.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        child: Text(
                          "+${item.kids.length}",
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
              Html(
                data: item.text,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
