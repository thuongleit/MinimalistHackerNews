import 'package:flutter/material.dart';
import 'package:hacker_news/utils/url_util.dart';
import '../../models/item.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class ItemRow extends StatelessWidget {
  final Item item;

  const ItemRow({Key key, this.item}) : super(key: key);

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation.slideIn(),
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(item.time * 1000);
    final TextStyle descriptionTextStyle =
        TextStyle(fontSize: 11.0, color: Colors.grey);

    return InkWell(
      child: Container(
        padding: EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: InkWell(
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
                    Text('${item.score}', style: descriptionTextStyle),
                  ],
                ),
                onTap: () {
                  _launchURL(context, item.getVoteUrl());
                },
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(4, 0, 0, 4)),
            Flexible(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      style: TextStyle(fontSize: 13.0),
                      softWrap: true,
                      maxLines: 1,
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 4)),
                    Row(
                      children: <Widget>[
                        Text(
                          "by ${item.by} ${item.url != null ? '(' + getBaseDomain(item.url) + ')' : ''}",
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
        if (item.url == null || item.url.isEmpty) {
          _launchURL(context, item.getContentUrl());
        } else {
          _launchURL(context, item.url);
        }
      },
    );
  }
}
