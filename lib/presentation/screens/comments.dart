import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../extensions/extensions.dart';
import '../../presentation/widgets/widgets.dart';
import '../../blocs/blocs.dart';

class CommentsScreen extends StatefulWidget {
  static Route route(BuildContext context, Item item) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<StoryCubit>(context),
        child: CommentsScreen(item),
      ),
    );
  }

  final Item item;

  const CommentsScreen(this.item, {Key key}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    context.read<StoryCubit>().getStory(widget.item.id);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customAppbar = SliverAppBar(
      leadingWidth: 24.0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.item.title}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              widget.item.description2,
              style: TextStyle(fontSize: 11.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
    return BlocBuilder<StoryCubit, NetworkState<Item>>(
      key: ObjectKey(widget.item),
      builder: (context, state) => SliverPage<StoryCubit>.display(
        context: context,
        controller: _scrollController,
        customAppBar: customAppbar,
        body: <Widget>[
          (state.isSuccess)
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildStoryRows(context, state.data.kids, index),
                    childCount: state.data.kids.length,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildStoryRows(
      BuildContext context, List<int> childItemIds, int index) {
    return BlocProvider(
      create: (_) {
        return StoryCubit(RepositoryProvider.of<StoriesRepository>(context))
          ..getStory(childItemIds[index]);
      },
      child: BlocBuilder<StoryCubit, NetworkState>(
        builder: (context, state) {
          return (state.isLoading)
              ? LoadingItem(count: 3)
              : (state.isFailure)
                  ? Container()
                  : _buildStoryRow(context, state.data, index);
        },
      ),
    );
  }

  Widget _buildStoryRow(BuildContext context, Item childItem, int index) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: false
          ? Container()
          : Slidable(
              key: ObjectKey(childItem),
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
                },
              ),
              child: CommentTile(childItem),
            ),
    );
  }
}
