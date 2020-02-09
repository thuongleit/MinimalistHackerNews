import 'package:flutter/material.dart';
import 'package:hacker_news/utils/url_util.dart';
import '../../models/item.dart';
import 'package:timeago/timeago.dart' as timeago;

class ItemRow extends StatelessWidget {
  final Item item;

  const ItemRow({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(item.time * 1000);
    //       return ListTile(
    //         leading: Column(
    //           children: <Widget>[
    //             Icon(Icons.arrow_drop_up),
    //             Text('${item.score}'),
    //           ],
    //         ),
    //         title: Text(item.title),
    //         subtitle: Text("by ${item.by} ${item.url != null ? '(' + getBaseDomain(item.url) + ')' : ''}"),
    //         trailing: Text('${timeago.format(date)}'),
    //   );
    // }

    return Container(
      padding: EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.arrow_drop_up, size: 24.0, color: Colors.grey),
                Text('${item.score}',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey))
              ],
            ),
          ),
          Flexible(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title,
                    style: TextStyle(fontSize: 12.0),
                    softWrap: true,
                    maxLines: 1,
                  ),
                  Text(
                    "by ${item.by} ${item.url != null ? '(' + getBaseDomain(item.url) + ')' : ''}",
                    style: TextStyle(fontSize: 10.0, color: Colors.grey),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
