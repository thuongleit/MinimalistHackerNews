import 'package:flutter/material.dart';
import 'package:hacker_news/presentation/widgets/item_title_text.dart';
import 'package:hknews_repository/hknews_repository.dart';

class TitleOnlyStoryTile extends StatelessWidget {
  final Item item;
  final Function(Item item) _onItemTap;

  const TitleOnlyStoryTile(this.item, {Key key, Function onItemTap})
      : assert(item != null),
        this._onItemTap = onItemTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: ItemTileText(item, maxLines: 2),
      ),
      onTap: () => (_onItemTap != null) ? _onItemTap(item) : null,
    );
  }
}
