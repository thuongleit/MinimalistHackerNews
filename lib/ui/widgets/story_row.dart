import 'package:flutter/material.dart';
import 'package:hacker_news/utils/url_util.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/story.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoryRow extends StatelessWidget {
  final Story story;

  const StoryRow({Key key, this.story}) : super(key: key);

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

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
                _launchInBrowser(story.voteUrl);
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
                      style: TextStyle(fontSize: 13.0),
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
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (story.url == null || story.url.isEmpty) {
          _launchInBrowser(story.contentUrl);
        } else {
          _launchInBrowser(story.url);
        }
      },
    );
  }
}
