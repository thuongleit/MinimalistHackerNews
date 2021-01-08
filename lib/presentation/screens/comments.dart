import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../extensions/extensions.dart';
import '../../presentation/widgets/widgets.dart';
import '../../blocs/blocs.dart';
import 'screens.dart';

class CommentsScreen extends StatefulWidget {
  static Route route(BuildContext context, Item item) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<StoryCubit>(
        create: (context) =>
            StoryCubit(RepositoryProvider.of<StoriesRepository>(context)),
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
  Item item;

  bool _showFab;

  @override
  void initState() {
    _scrollController = ScrollController();
    item = widget.item;
    context.read<StoryCubit>().getStory(item.id);
    _showFab = true;
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showFab) {
          setState(() {
            _showFab = false;
          });
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showFab) {
          setState(() {
            _showFab = true;
          });
        }
      }
    });
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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.title}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              item.description2,
              style: TextStyle(fontSize: 11.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
    return BlocConsumer<StoryCubit, NetworkState<Item>>(
      key: ObjectKey(item),
      listenWhen: (previous, current) => current.isSuccess,
      listener: (context, state) => setState(() => item = state.data),
      builder: (context, state) => Scaffold(
        body: UserActionsListener(
          child: SliverPage<StoryCubit>.display(
            context: context,
            controller: _scrollController,
            customAppBar: customAppbar,
            dataEmptyCondition: () => state.data?.kids?.isEmpty,
            viewIfEmptyData: Builder(
              builder: (context) => BigTip(
                title: const Text('No comments yet'),
                subtitle: const Text('Be the first to say something'),
                action: Text(
                  'Add a comment'.toUpperCase(),
                  style: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                      .subtitle1
                      .copyWith(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                actionCallback: () => _goToReply(context),
                child: const Icon(Icons.comment_bank_outlined),
              ),
            ),
            loading: ListView.builder(
              itemBuilder: (context, index) => LoadingItem(count: 2),
              itemCount: 20,
            ),
            body: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildCommentRows(context, state.data.kids, index),
                childCount: (state.data?.kids?.length ?? 0),
              ),
            ),
          ),
        ),
        floatingActionButton: (state.data?.kids?.isNotEmpty == true && _showFab)
            ? Builder(
                builder: (context) => FloatingActionButton(
                  child: Icon(Icons.reply),
                  onPressed: () => _goToReply(context),
                ),
              )
            : null,
      ),
    );
  }

  Future<void> _goToReply(BuildContext context) async {
    final bool replySuccess = await NavigatorX.removeSnackBarAndPush(
      context,
      CommentReplyScreen.route(context, item),
    );

    if (replySuccess == true) {
      context.read<StoryCubit>().refresh();
    }
  }

  Widget _buildCommentRows(
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
                  : _buildCommentRow(context, state.data);
        },
      ),
    );
  }

  Widget _buildCommentRow(BuildContext context, Item commentItem) {
    return BlocProvider<CommentsCubit>(
      create: (context) => CommentsCubit(
        RepositoryProvider.of<StoriesRepository>(context),
      ),
      child: CommentTile(
        key: ObjectKey(commentItem),
        item: commentItem,
      ),
    );
  }
}
