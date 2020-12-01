import 'package:flutter/material.dart';
import 'package:hknews_repository/hknews_repository.dart';

typedef OnReplyDismissed = Function(bool cancelled);

class CommentReplyView extends StatelessWidget {
  CommentReplyView({
    @required this.parentItem,
    this.onReplyDismissed,
  });

  final Item parentItem;
  final OnReplyDismissed onReplyDismissed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
      onLongPress: () => {},
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.red,
                  onPressed: () => {onReplyDismissed?.call(true)},
                ),
                IconButton(
                  icon: Icon(Icons.format_quote_sharp),
                  color: Colors.grey[600],
                  onPressed: () => {},
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.2),
                  ),
                  hintText: 'Enter your comment',
                ),
                style: TextStyle(fontSize: 13.0),
                maxLines: 7,
                minLines: 3,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              color: Theme.of(context).primaryColor,
              onPressed: () => {onReplyDismissed?.call(false)},
            ),
          ],
        ),
      ),
    );
  }
}
