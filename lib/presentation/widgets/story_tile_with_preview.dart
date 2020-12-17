import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../blocs/blocs.dart';
import '../../extensions/extensions.dart';
import 'item_description_text.dart';
import 'item_title_text.dart';
import 'up_vote.dart';
import 'widgets.dart';

class ContentPreviewStoryTile extends StatelessWidget {
  final Item item;
  final bool voteable;

  const ContentPreviewStoryTile(this.item, {Key key, this.voteable = true})
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
          const Padding(padding: const EdgeInsets.only(left: 4.0)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ItemTileText(item),
                  Container(
                    margin: const EdgeInsets.only(top: 4.0, bottom: 6.0),
                    child: Row(
                      children: <Widget>[
                        ItemDescriptionText(item.description1),
                        Expanded(child: Container()),
                        ItemDescriptionText(item.timeAgo),
                      ],
                    ),
                  ),
                  BlocProvider<StoryContentCubit>(
                    create: (_) => StoryContentCubit(
                      RepositoryProvider.of<StoriesRepository>(context),
                    )..get(item.id),
                    child: BlocBuilder<StoryContentCubit, NetworkState<String>>(
                      builder: (context, state) => (state.isLoading)
                          ? LoadingItem(
                              count: 3,
                              height: 13.0,
                              padding: EdgeInsets.zero,
                            )
                          : (state.isSuccess)
                              ? Text(
                                  state.data ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.grey,
                                  ),
                                )
                              : Container(),
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
