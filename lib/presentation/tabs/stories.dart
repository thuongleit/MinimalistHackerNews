import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
    BlocProvider.of<StoriesBloc>(context).add(LoadStories(widget.storyType));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesBloc, NetworkState>(
      key: ObjectKey(widget.storyType),
      builder: (context, state) => SliverPage<StoriesBloc>.display(
        context: context,
        controller: widget.scrollController,
        title: FlutterI18n.translate(
          context,
          widget.storyType.tabTitle,
        ),
        opacity: null,
        counter: null,
        slides: null,
        popupMenu: Menu.home,
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
          StoryCubit(storyIds[index], StoriesRepositoryImpl())..fetchData(),
      child: Container(
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
      ),
    );
  }

  Widget _buildStoryRow(BuildContext context, Story story, int index) {
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
        BlocProvider.of<StoriesBloc>(context).add(SaveStory(story, index));
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
                onPressed: () => BlocProvider.of<StoriesBloc>(context)
                    .add(UnSaveStory(story, index)),
              ),
            ),
          );
      },
      child: StoryRow(
        story: story,
      ),
    );
  }
}
