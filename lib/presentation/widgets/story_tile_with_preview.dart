import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../extensions/extensions.dart';
import 'item_description_text.dart';
import 'item_title_text.dart';
import 'up_vote.dart';
import '../../blocs/blocs.dart';

class ContentPreviewStoryTile extends StatelessWidget {
  final Item item;

  const ContentPreviewStoryTile(this.item, {Key key})
      : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  const Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 4)),
                  Row(
                    children: <Widget>[
                      ItemDescriptionText(item.description1),
                      Expanded(child: Container()),
                      ItemDescriptionText(item.timeAgo),
                    ],
                  ),
                  const Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 4)),
                  ItemDescriptionText(
                    item.text ?? '',
                    maxLines: 3,
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
