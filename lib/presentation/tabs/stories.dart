import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide showMenu;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:share/share.dart';

import '../widgets/widgets.dart';
import '../../utils/menu.dart';
import '../../extensions/extensions.dart';
import '../../blocs/blocs.dart';
import '../../presentation/screens/screens.dart';
import '../../utils/utils.dart' as utils;

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
    context.read<StoriesCubit>().getStories(widget.storyType);
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
      key: ObjectKey(storyIds[index]),
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
        Builder(
          builder: (context) => MyCustomIconSlideAction(
            color: Colors.grey[500],
            icon: Icons.more_vert_outlined,
            foregroundColor: Colors.white,
            onTap: () async {
              if (await _showItemContextMenu(context, item)) {
                Slidable.of(context)?.close();
              }
            },
            onTapDown: storePosition,
            closeOnTap: false,
          ),
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
            _voteItem(context, item);
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
      popupMenu['app.menu.logout'] =
          () => utils.Dialog.showLogoutDialog(context);
    } else {
      popupMenu['app.menu.login'] = () => utils.Dialog.showLoginDialog(context);
    }

    popupMenu.addAll(Menu.home);

    return popupMenu;
  }

  void _onItemTap(Item item) {
    if (item.url == null || item.url.isEmpty) {
      utils.UrlUtils.openWebBrowser(context, item.hackerNewsUrl);
    } else {
      utils.UrlUtils.openWebBrowser(context, item.url);
    }
  }

  Future<bool> _showItemContextMenu(BuildContext context, Item item) async {
    final chosenOption = await showMenu(
      context: context,
      item: ItemPopupMenuEntry(items: Menu.story_popup_menu),
    );
    if (chosenOption == null) return false;

    if (chosenOption == PopupMenu.viewComment) {
      _goToComment(context, item);
      return true;
    } else if (chosenOption == PopupMenu.vote) {
      _voteItem(context, item);
      return true;
    } else if (chosenOption == PopupMenu.share) {
      final shareChosen = await showMenu(
        context: context,
        item: ItemPopupMenuEntry(items: Menu.share_popup_menu),
      );
      if (shareChosen == null) return false;

      if (shareChosen == PopupMenu.shareHKNewsArticle) {
        await Share.share('${item.title}\n\n${item.hackerNewsUrl}',
            subject: '${item.title}');
        return true;
      } else if (shareChosen == PopupMenu.shareRealArticle) {
        await Share.share('${item.title}\n\n${item.url}',
            subject: '${item.title}');
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void _voteItem(BuildContext context, Item item) {
    context.read<UserActionBloc>().add(UserVoteRequested(item.id));
  }

  void _goToComment(BuildContext context, Item item) {
    Navigator.push(
      context,
      CommentsScreen.route(context, item),
    );
  }
}
