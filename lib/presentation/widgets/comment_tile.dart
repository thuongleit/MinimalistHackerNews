import 'package:flutter/material.dart' hide showMenu;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hacker_news/presentation/screens/comment_reply.dart';
import 'package:hacker_news/presentation/widgets/single_comment_tile.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../blocs/blocs.dart';
import 'widgets.dart';

class CommentTile extends StatefulWidget {
  const CommentTile({
    @required this.item,
    Key key,
    this.requestChildren = true,
    this.isCollapsed = false,
  }) : super(key: key);

  final Item item;
  final bool requestChildren;
  final bool isCollapsed;

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> with CustomPopupMenu {
  bool isCollapsed;

  @override
  void initState() {
    this.isCollapsed = widget.isCollapsed;
    if (!isCollapsed && widget.item.kids.isNotEmpty) {
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
          color: Colors.deepOrange,
          icon: Icons.thumb_up,
          onTap: () => context
              .read<UserActionBloc>()
              .add(UserVoteRequested(widget.item.id)),
        ),
      ],
      secondaryActions: [
        IconSlideAction(
          color: Colors.green[700],
          icon: Icons.reply,
          onTap: () => _onReplyRequest(context, widget.item),
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
            if (actionType == SlideActionType.primary) {
              context
                  .read<UserActionBloc>()
                  .add(UserVoteRequested(widget.item.id));
            } else {
              _onReplyRequest(context, widget.item);
            }
            return false;
          }),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.only(
            top: 8,
            left: 8.0 * widget.item.depth * 0.5,
            bottom: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleCommentTile(
                item: widget.item,
                isCollapsed: isCollapsed,
              ),
              (!isCollapsed &&
                      widget.requestChildren &&
                      widget.item.kids.isNotEmpty)
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
        onTap: () => setState(() => isCollapsed = !isCollapsed),
        onTapDown: storePosition,
        onLongPress: () => _showItemContextMenu(context, widget.item),
      ),
    );
  }

  Widget _buildChildCommentTile(BuildContext context, Item item) {
    return BlocProvider<CommentCubit>(
      create: (context) => CommentCubit(
        RepositoryProvider.of<StoriesRepository>(context),
      ),
      child: CommentTile(
        item: item,
      ),
    );
  }

  void _showItemContextMenu(BuildContext context, Item item) async {
    var chosenOption = await showMenu(
      context: context,
      items: <PopupMenuEntry<int>>[PlusMinusEntry()],
    );
    if (chosenOption == null) return;

    if (chosenOption == 0) {}
  }

  void _onReplyRequest(BuildContext context, Item item) {
    Navigator.push(
      context,
      CommentReplyScreen.route(context, item),
    );
  }
}
