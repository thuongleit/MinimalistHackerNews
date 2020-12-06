import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:provider/provider.dart';

import '../../blocs/blocs.dart';
import '../widgets/widgets.dart';
import '../../utils/menu.dart';
import '../../utils/url_util.dart';
import '../../extensions/extensions.dart';

class SavedStoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenTitle =
        FlutterI18n.translate(context, 'app.menu.saved_stories');
    return BlocProvider<SavedStoriesCubit>(
      create: (context) =>
          SavedStoriesCubit(RepositoryProvider.of<StoriesRepository>(context))
            ..getSavedStories(),
      child: BlocBuilder<SavedStoriesCubit, NetworkState>(
        builder: (context, state) => (state.isSuccess && state.data.isEmpty)
            ? SimplePage(
                title: screenTitle,
                body: BigTip(
                  title: Text(
                    FlutterI18n.translate(context,
                        'screen.saved_stories.hint_message.no_saved_stories_title'),
                  ),
                  subtitle: Text(
                    FlutterI18n.translate(context,
                        'screen.saved_stories.hint_message.swipe_to_save'),
                  ),
                  action: Text(
                    FlutterI18n.translate(
                        context, 'screen.saved_stories.hint_message.action'),
                  ),
                  actionCallback: () => Navigator.pop(context),
                  child: Icon(Icons.swipe),
                ),
              )
            : Scaffold(
                body: SliverPage<SavedStoriesCubit>.display(
                  context: context,
                  controller: null,
                  title: screenTitle,
                  popupMenu: Menu.home,
                  enablePullToRefresh: false,
                  body: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildStoryRow(context, state.data[index], index),
                      childCount: state.data?.length ?? 0,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStoryRow(BuildContext context, Item item, int index) {
    final viewMode = context.watch<ViewModeCubit>().state;
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Center(
              child: Text(
                FlutterI18n.translate(context, 'app.action.delete'),
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
        context.read<UserActionBloc>().add(UserUnSaveStoryRequested(item));
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                FlutterI18n.translate(
                    context, 'screen.saved_stories.story_unsaved'),
              ),
              action: SnackBarAction(
                label: FlutterI18n.translate(context, 'app.action.undo'),
                onPressed: () => context
                    .read<UserActionBloc>()
                    .add(UserSaveStoryRequested(item)),
              ),
            ),
          );
      },
      child: InkWell(
        child: (viewMode == ViewMode.titleOnly)
            ? TitleOnlyStoryTile(item)
            : (viewMode == ViewMode.minimalist)
                ? MinimalistStoryTile(item)
                : ContentPreviewStoryTile(item),
        onTap: () => _onItemTap(context, item),
      ),
    );
  }

  void _onItemTap(BuildContext context, Item item) {
    if (item.url == null || item.url.isEmpty) {
      UrlUtils.openWebBrowser(context, item.contentUrl);
    } else {
      UrlUtils.openWebBrowser(context, item.url);
    }
    context.read<UserActionBloc>().add(UserUpdateVisitRequested(item));
  }
}
