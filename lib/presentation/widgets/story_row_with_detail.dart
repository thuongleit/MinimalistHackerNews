import 'package:flutter/material.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../utils/url_util.dart';
import '../../extensions/extensions.dart';

class WithDetailStoryRow extends StatelessWidget {
  final Item story;
  final Function(Item story) onItemTap;

  const WithDetailStoryRow(this.story, {Key key, this.onItemTap})
      : assert(story != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(story.time * 1000);
    final TextStyle descriptionTextStyle =
        TextStyle(fontSize: 11.0, color: Colors.grey);

    var commentDescription;

    if (story.descendants > 1) {
      commentDescription = '${story.descendants}✍︎';
    } else if (story.descendants == 1) {
      commentDescription = '${story.descendants}✍︎';
    }

    return InkWell(
      child: Container(
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
                  Text(
                    String.fromCharCode(Icons.arrow_drop_up.codePoint),
                    style: TextStyle(
                        fontFamily: Icons.arrow_drop_up.fontFamily,
                        package: Icons.arrow_drop_up.fontPackage,
                        fontSize: 24.0,
                        color: Colors.grey),
                  ),
                  Text('${story.score}', style: descriptionTextStyle),
                ],
              ),
              onTap: () {
                openWebBrowser(context, story.voteUrl);
              },
            ),
            const Padding(padding: const EdgeInsets.fromLTRB(4, 0, 0, 4)),
            Flexible(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      story.title,
                      style: TextStyle(
                          fontSize: 13.0,
                          color:
                              story.visited ? Colors.grey[600] : Colors.black),
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4)),
                    Row(
                      children: <Widget>[
                        Text(
                          "by ${story.by} ${story.url != null ? '(' + getBaseDomain(story.url) + ')' : ''} ${story.descendants > 0 ? ' | ' + commentDescription : ''}",
                          style: descriptionTextStyle,
                        ),
                        Expanded(child: Container()),
                        Text(
                          '${timeago.format(date)}',
                          style: descriptionTextStyle,
                        ),
                      ],
                    ),
                    const Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4)),
                    Text(
                      '${story.text}',
                      style: descriptionTextStyle,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (onItemTap != null) {
          onItemTap(story);
        }
        if (story.url == null || story.url.isEmpty) {
          openWebBrowser(context, story.contentUrl);
        } else {
          openWebBrowser(context, story.url);
        }
      },
    );
  }
}
