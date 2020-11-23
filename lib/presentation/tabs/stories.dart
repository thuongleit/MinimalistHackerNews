import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hacker_news/presentation/widgets/login_form.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../widgets/widgets.dart';
import '../../utils/menu.dart';
import '../../extensions/extensions.dart';
import '../../blocs/blocs.dart';

class StoriesTab extends StatefulWidget {
  final StoryType storyType;
  final ScrollController scrollController;

  const StoriesTab({Key key, this.storyType, this.scrollController})
      : assert(storyType != null),
        super(key: key);

  @override
  _StoriesTabState createState() => _StoriesTabState();
}

class _StoriesTabState extends State<StoriesTab> {
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
        opacity: null,
        counter: null,
        slides: null,
        popupMenu: _buildPopupMenu(context),
        actions: Menu.home_actions
            .map((action) => _buildMenuAction(context, action))
            .toList(),
        body: <Widget>[
          (state.isSuccess)
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildStoryRows(context, state.data, index),
                    childCount: state.data.length,
                  ),
                )
              : Container(),
        ],
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
    return BlocProvider(
      create: (_) =>
          StoryCubit(RepositoryProvider.of<StoriesRepository>(context))
            ..getStory(storyIds[index],
                contentPreview:
                    context.read<ViewModeCubit>().state == ViewMode.withDetail),
      child: BlocBuilder<StoryCubit, NetworkState>(
        builder: (context, state) {
          if (state.isLoading) {
            return FadeLoading();
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

  Widget _buildStoryRow(BuildContext context, Item story, int index) {
    final viewMode = context.watch<ViewModeCubit>().state;
    return Dismissible(
      key: ValueKey(story.id),
      background: Container(
        color: Colors.green[700],
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Center(
              child: Text(
                FlutterI18n.translate(context, 'app.action.read_later'),
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Container(),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        context.read<StoriesCubit>().saveStory(story, index);
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                FlutterI18n.translate(context, 'app.message.story_saved'),
              ),
              action: SnackBarAction(
                label: FlutterI18n.translate(context, 'app.action.undo')
                    .toUpperCase(),
                onPressed: () =>
                    context.read<StoriesCubit>().unsaveStory(story, index),
              ),
            ),
          );
      },
      child: (viewMode == ViewMode.titleOnly)
          ? TitleOnlyStoryRow(story)
          : (viewMode == ViewMode.minimalist)
              ? MinimalistStoryRow(story)
              : WithDetailStoryRow(story),
    );
  }

  Map<String, dynamic> _buildPopupMenu(BuildContext context) {
    final Map<String, dynamic> popupMenu = {};
    //add login/logout popup menu
    var authenticationStatus = context.watch<AuthenticationBloc>().state.status;
    if (authenticationStatus.isUnauthenticated) {
      popupMenu['app.menu.login'] = () => showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text(FlutterI18n.translate(context, 'app.menu.login')),
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
    } else {
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
                  onPressed: () => context
                      .watch<AuthenticationBloc>()
                      .add(AuthenticationLogoutRequested()),
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
    }

    popupMenu.addAll(Menu.home);

    return popupMenu;
  }
}
