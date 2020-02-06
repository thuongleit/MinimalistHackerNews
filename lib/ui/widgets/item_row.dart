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
        return ListTile(
          leading: Column(
            children: <Widget>[
              Icon(Icons.arrow_drop_up),
              Text('${item.score}'),
            ],
          ),
          title: Text(item.title),
          subtitle: Text('by ${item.by} (${getBaseDomain(item.url)})'),
          trailing: Text('${timeago.format(date)}'),
    );
  }
}
