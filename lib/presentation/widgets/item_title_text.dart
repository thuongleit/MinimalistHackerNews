import 'package:flutter/material.dart';
import 'package:hknews_repository/hknews_repository.dart';

class ItemTileText extends Text {
  ItemTileText(Item item, {Key key, int maxLines = 1})
      : assert(item != null),
        super(
          item.title ?? '',
          key: key,
          style: TextStyle(
              fontSize: 13.0,
              color: item.visited ? Colors.grey[600] : Colors.black),
          textAlign: TextAlign.justify,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        );
}
