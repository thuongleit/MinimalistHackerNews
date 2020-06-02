import 'package:flutter/material.dart';
import 'package:hacker_news/utils/url_util.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/item.dart';
import 'package:timeago/timeago.dart' as timeago;

class ItemRow extends StatelessWidget {
  final Item item;

  const ItemRow({Key key, this.item}) : super(key: key);

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
    DateTime date = DateTime.fromMillisecondsSinceEpoch(item.time * 1000);
    final TextStyle descriptionTextStyle =
        TextStyle(fontSize: 11.0, color: Colors.grey);

    var commentDescription;

    if (item.descendants > 1) {
      commentDescription = '${item.descendants} comments';
    } else if (item.descendants == 1) {
      commentDescription = '${item.descendants} comment';
    }

    return InkWell(
      child: Dismissible(
        key: Key(item.id.toString()),
//        background: slideRightToLeftBackground(),
        background: slideLeftToRightBackground(),
        onDismissed: (direction) => onDragDismissed(context, direction),
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
                    _launchInBrowser(item.getVoteUrl());
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
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 4)),
                      Row(
                        children: <Widget>[
//                        item.descendants > 0
//                            ? InkWell(
//                                child: Row(
//                                  children: <Widget>[
//                                    Text(
//                                      '${item.descendants}',
//                                      style: descriptionTextStyle,
//                                    ),
//                                    Icon(
//                                      Icons.chat,
//                                      size: 16.0,
//                                      color: Colors.grey,
//                                    )
//                                  ],
//                                ),
//                                onTap: () {
//                                  _launchURL(context, item.getContentUrl());
//                                },
//                              )
//                            : Container(),
                          Text(
                            "by ${item.by} ${item.url != null ? '(' + getBaseDomain(item.url) + ')' : ''} ${item.descendants > 0 ? ' | ' + commentDescription : ''}",
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
      ),
      onTap: () {
        if (item.url == null || item.url.isEmpty) {
          _launchInBrowser(item.getContentUrl());
        } else {
          _launchInBrowser(item.url);
        }
      },
    );
  }

  Widget slideRightToLeftBackground() {
    return Container(
      color: Colors.blue,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 20),
            Icon(Icons.save, color: Colors.white),
            Text(
              " Read later",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftToRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.comment, color: Colors.white),
            Text(
              " Go To Comment",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  onDragDismissed(BuildContext context, DismissDirection direction) {
    if (direction == DismissDirection.endToStart) {
      _launchInBrowser(item.getContentUrl());
      print('Go To Comment');
    } else {
      print('Read later');
    }
  }
}
