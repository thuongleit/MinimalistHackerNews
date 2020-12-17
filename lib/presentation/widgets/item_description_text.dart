import 'package:flutter/material.dart';

class ItemDescriptionText extends Text {
  const ItemDescriptionText(String data, {Key key, int maxLines = 1})
      : assert(data != null),
        super(
          data,
          key: key,
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
          maxLines: maxLines,
        );
}
