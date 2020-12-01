import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:hknews_repository/hknews_repository.dart';

import '../../extensions/extensions.dart';
import 'widgets.dart';
import '../../blocs/blocs.dart';

class CommentTile extends StatefulWidget {
  const CommentTile(
    this.item, {
    Key key,
    this.onItemTap,
    this.onItemLongPress,
    this.isCollapsed = false,
  }) : super(key: key);

  final Item item;
  final bool isCollapsed;
  final Function() onItemTap;
  final Function() onItemLongPress;

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  @override
  void initState() {
    if (!widget.isCollapsed && widget.item.kids.isNotEmpty) {
      BlocProvider.of<CommentCubit>(context).getComments(widget.item);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ObjectKey(widget.item),
      closeOnScroll: true,
      actionPane: SlidableScrollActionPane(),
      actions: <Widget>[
        IconSlideAction(
          color: Colors.deepOrangeAccent,
          icon: Icons.how_to_vote,
        ),
      ],
      dismissal: SlidableDismissal(
          closeOnCanceled: true,
          dismissThresholds: {
            SlideActionType.primary: 0.2,
            SlideActionType.secondary: 0.2,
          },
          child: SlidableDrawerDismissal(),
          onWillDismiss: (actionType) {
            return false;
          }),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.only(
            top: 8,
            left: 8.0 * widget.item.depth * 0.75,
            bottom: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '• ${widget.item.by}, ${widget.item.score > 0 ? '${widget.item.score} points, ' : ''} ${widget.item.timeAgo}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          TextSpan(
                            text:
                                ' [${widget.isCollapsed ? '+${widget.item.kids.length + 1} more' : '-'}]',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              (!widget.isCollapsed)
                  ? Html(data: widget.item.text)
                  : Container(),
              (!widget.isCollapsed && widget.item.kids.isNotEmpty)
                  ? BlocBuilder<CommentCubit, NetworkState<List<Item>>>(
                      builder: (context, state) {
                        return (state.isLoading)
                            ? LoadingItem(count: 2)
                            : (state.isFailure)
                                ? Container()
                                : Column(
                                    children: [
                                      for (final item in state.data)
                                        _buildChildCommentTile(context, item)
                                    ],
                                  );
                      },
                    )
                  : Container(),
            ],
          ),
        ),
        onTap: widget.onItemTap,
        onLongPress: widget.onItemTap,
      ),
    );
  }

  Widget _buildChildCommentTile(BuildContext context, Item item) {
    return BlocProvider<CommentCubit>(
      create: (context) => CommentCubit(
        RepositoryProvider.of<StoriesRepository>(context),
      ),
      child: CommentTile(
        item,
      ),
    );
  }
}