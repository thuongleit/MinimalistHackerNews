import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hacker_news/presentation/widgets/item_title_text.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../blocs/blocs.dart';
import '../../extensions/extensions.dart';
import 'item_description_text.dart';
import 'up_vote.dart';

class MinimalistStoryTile extends StatelessWidget {
  final Item item;
  final Function(Item item) _onItemTap;

  const MinimalistStoryTile(this.item, {Key key, Function onItemTap})
      : assert(item != null),
        this._onItemTap = onItemTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  UpVote(),
                  ItemDescriptionText('${item.score}'),
                ],
              ),
              onTap: () => BlocProvider.of<UserActionBloc>(context)
                  .add(UserVoteRequested(item.id)),
            ),
            const Padding(padding: const EdgeInsets.fromLTRB(4, 0, 0, 4)),
            Flexible(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ItemTileText(item),
                    const Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                    ),
                    Row(
                      children: <Widget>[
                        ItemDescriptionText(item.description),
                        Expanded(child: Container()),
                        ItemDescriptionText(item.timeAgo),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => (_onItemTap != null) ? _onItemTap(item) : null,
    );
  }
}
