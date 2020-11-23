import 'package:flutter/material.dart';
import 'package:hacker_news/presentation/widgets/item_description_text.dart';
import 'package:hacker_news/presentation/widgets/item_title_text.dart';
import 'package:hacker_news/presentation/widgets/up_vote.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../utils/url_util.dart';
import '../../extensions/extensions.dart';

class ContentPreviewStoryTile extends StatelessWidget {
  final Item item;
  final Function(Item item) _onItemTap;

  const ContentPreviewStoryTile(this.item, {Key key, Function onItemTap})
      : assert(item != null),
        this._onItemTap = onItemTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  UpVote(),
                  ItemDescriptionText('${item.score}'),
                ],
              ),
              onTap: () {
                openWebBrowser(context, item.voteUrl);
              },
            ),
            const Padding(padding: const EdgeInsets.fromLTRB(4, 0, 0, 4)),
            Flexible(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ItemTileText(item),
                    const Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4)),
                    Row(
                      children: <Widget>[
                        ItemDescriptionText(item.description),
                        Expanded(child: Container()),
                        ItemDescriptionText(item.timeAgo),
                      ],
                    ),
                    const Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4)),
                    ItemDescriptionText(
                      item.text ?? '',
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => (_onItemTap != null) ? _onItemTap(item) : null,
    );
  }
}
