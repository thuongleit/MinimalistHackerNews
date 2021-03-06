import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../blocs/blocs.dart';
import '../../extensions/extensions.dart';
import 'item_description_text.dart';
import 'item_title_text.dart';
import 'up_vote.dart';

class MinimalistStoryTile extends StatelessWidget {
  final Item item;
  final bool voteable;

  const MinimalistStoryTile(this.item, {Key key, this.voteable = true})
      : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                UpVote(),
                ItemDescriptionText('${item.score}'),
              ],
            ),
            onTap: voteable
                ? () => BlocProvider.of<UserActionBloc>(context)
                    .add(UserVoteRequested(item.id))
                : null,
          ),
          const Padding(padding: const EdgeInsets.only(left: 8.0)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ItemTileText(item),
                  Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: <Widget>[
                        ItemDescriptionText(item.description1),
                        Expanded(child: Container()),
                        ItemDescriptionText(item.timeAgo),
                      ],
                    ),
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
