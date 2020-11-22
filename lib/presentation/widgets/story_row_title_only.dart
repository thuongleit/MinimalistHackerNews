import 'package:flutter/material.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../utils/url_util.dart';
import '../../extensions/extensions.dart';

class TitleOnlyStoryRow extends StatelessWidget {
  final Item story;
  final Function(Item story) onItemTap;

  const TitleOnlyStoryRow(this.story, {Key key, this.onItemTap})
      : assert(story != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: Text(
          story.title,
          style: TextStyle(
              fontSize: 13.0,
              color: story.visited ? Colors.grey[600] : Colors.black),
          maxLines: 2,
          textAlign: TextAlign.justify,
          overflow: TextOverflow.ellipsis,
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
