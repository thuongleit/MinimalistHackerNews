import 'package:flutter/material.dart';
import 'package:hknews_repository/hknews_repository.dart';

import 'item_title_text.dart';

class TitleOnlyStoryTile extends StatelessWidget {
  final Item item;

  const TitleOnlyStoryTile(this.item, {Key key})
      : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: ItemTileText(item, maxLines: 2),
    );
  }
}
