import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide showMenu;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hacker_news/presentation/screens/comments.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../widgets/widgets.dart';
import '../../utils/menu.dart';
import '../../extensions/extensions.dart';
import '../../blocs/blocs.dart';
import '../../utils/url_util.dart';

class StoriesTab extends StatefulWidget {
  final StoryType storyType;
  final ScrollController scrollController;

  const StoriesTab({Key key, this.storyType, this.scrollController})
      : assert(storyType != null),
        super(key: key);

  @override
  _StoriesTabState createState() => _StoriesTabState();
}

class _StoriesTabState extends State<StoriesTab> with CustomPopupMenu {
  @override
  void initState() {
    context.read<StoriesCubit>().fetchStories(widget.storyType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesCubit, NetworkState>(
      key: ObjectKey(widget.storyType),
      builder: (context, state) => SliverPage<StoriesCubit>.display(
        context: context,
        controller: widget.scrollController,
        title: FlutterI18n.translate(
          context,
          widget.storyType.tabTitle,
        ),
        popupMenu: _buildPopupMenu(context),
        actions: Menu.home_actions
            .map((action) => _buildMenuAction(context, action))
            .toList(),
        body: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildStoryRows(context, state.data, index),
            childCount: state.data?.length ?? 0,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuAction(BuildContext context, Map<String, Object> action) {
    return IconButton(
      tooltip: action['title'],
      onPressed: () => Navigator.pushNamed(context, action['route']),
      icon: Icon(action['icon']),
    );
  }

  Widget _buildStoryRows(BuildContext context, List<int> storyIds, int index) {
    final viewMode = context.read<ViewModeCubit>().state;
    return BlocProvider(
      create: (_) {
        return StoryCubit(RepositoryProvider.of<StoriesRepository>(context))
          ..getStory(storyIds[index],
              contentPreview: viewMode == ViewMode.withDetail);
      },
      child: BlocBuilder<StoryCubit, NetworkState>(
        builder: (context, state) {
          if (state.isLoading) {
            return LoadingItem(
              count: (viewMode == ViewMode.titleOnly) ? 1 : 2,
            );
          } else if (state.isFailure) {
            print('error = ${state.error}');
            return Container();
          } else {
            return _buildStoryRow(context, state.data, index);
          }
        },
      ),
    );
  }

  Widget _buildStoryRow(BuildContext context, Item item, int index) {
    final viewMode = context.watch<ViewModeCubit>().state;
    return Slidable(
      key: ValueKey(item.id),
      closeOnScroll: true,
      actionPane: SlidableScrollActionPane(),
      actions: <Widget>[
        IconSlideAction(
          color: Colors.deepOrange,
          icon: Icons.thumb_up,
          onTap: () =>
              context.read<UserActionBloc>().add(UserVoteRequested(item.id)),
        ),
        IconSlideAction(
          color: Colors.blueAccent,
          icon: Icons.save,
          onTap: () =>
              context.read<UserActionBloc>().add(UserSaveStoryRequested(item)),
        ),
      ],
      secondaryActions: [
        IconSlideAction(
          color: Colors.grey[500],
          icon: Icons.more_vert_outlined,
          foregroundColor: Colors.white,
          onTap: () => _showItemContextMenu(context, item),
          closeOnTap: false,
        ),
        IconSlideAction(
          color: Colors.green[700],
          icon: Icons.comment,
          onTap: () => _goToComment(context, item),
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
            context.read<UserActionBloc>().add(UserVoteRequested(item.id));
          } else {
            _goToComment(context, item);
          }
          return false;
        },
      ),
      child: InkWell(
        child: (viewMode == ViewMode.titleOnly)
            ? TitleOnlyStoryTile(item)
            : (viewMode == ViewMode.minimalist)
                ? MinimalistStoryTile(item)
                : ContentPreviewStoryTile(item),
        onTap: () => _onItemTap(item),
        onTapDown: storePosition,
        onLongPress: () => _showItemContextMenu(context, item),
      ),
    );
  }

  Map<String, dynamic> _buildPopupMenu(BuildContext context) {
    final Map<String, dynamic> popupMenu = {};
    //add login/logout popup menu
    var authenticationStatus = context.watch<AuthenticationBloc>().state.status;
    if (authenticationStatus == Authentication.authenticated) {
      popupMenu['app.menu.logout'] = () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text('Are you sure to logout?'),
              ),
              actions: [
                TextButton(
                  key: const ValueKey('logout_dialog_ok_button'),
                  onPressed: () {
                    context
                        .read<AuthenticationBloc>()
                        .add(AuthenticationLogoutRequested());
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
                TextButton(
                  key: const ValueKey('logout_dialog_cancel_button'),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
              ],
            ),
          );
    } else {
      popupMenu['app.menu.login'] = () => showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text('Login with HackerNews'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: BlocProvider(
                    create: (context) {
                      return LoginBloc(
                        authenticationRepository:
                            RepositoryProvider.of<AuthenticationRepository>(
                                context),
                      );
                    },
                    child: LoginForm(),
                  ),
                ),
              ],
            ),
          );
    }

    popupMenu.addAll(Menu.home);

    return popupMenu;
  }

  void _onItemTap(Item item) {
    if (item.url == null || item.url.isEmpty) {
      openWebBrowser(context, item.contentUrl);
    } else {
      openWebBrowser(context, item.url);
    }
  }

  void _showItemContextMenu(BuildContext context, Item item) async {
    var chosenOption = await showMenu(
      context: context,
      items: <PopupMenuEntry<int>>[PlusMinusEntry()],
    );
    if (chosenOption == null) return;

    if (chosenOption == 0) {
      _goToComment(context, item);
    }
  }

  void _goToComment(BuildContext context, Item item) {
    Navigator.push(
      context,
      CommentsScreen.route(context, item),
    );
  }
}
