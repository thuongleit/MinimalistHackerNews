import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        item.title ?? '',
        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
        textAlign: TextAlign.justify,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
