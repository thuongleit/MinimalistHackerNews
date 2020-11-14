import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../widgets/widgets.dart';
import '../../utils/menu.dart';
import '../../extensions/extensions.dart';
import '../../blocs/blocs.dart';

class StoriesTab extends StatelessWidget {
  final StoryType storyType;
  final ScrollController scrollController;

  const StoriesTab({Key key, this.storyType, this.scrollController})
      : assert(storyType != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesBloc, NetworkState>(
      builder: (context, state) => Scaffold(
        body: SliverPage<StoriesBloc>.display(
          context: context,
          controller: scrollController,
          title: FlutterI18n.translate(
            context,
            storyType.tabTitle,
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
                      _buildStoryRows,
                      childCount: state.data.length,
                    ),
                  )
                : Container(),
          ],
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

  // Widget _buildStoryRows(BuildContext context, int index) {
  //   return BlocListener < StoriesBloc
  //   , NetworkState>(
  //   listener: (context, state) {
  //   if (state is StoryLoaded) {
  //   if (state is StoryLoaded) {
  //   if (state is StoryLoaded) {
  //   return Container(
  //   child: (repository.stories[storyId] != null)
  //   ? _buildStoryRow(context, repository.stories[storyId], index)
  //       : FutureBuilder(
  //   future: repository.getStory(storyId),
  //   builder: (context, snapshot) {
  //   if (snapshot.hasData && snapshot.data != null) {
  //   var story = snapshot.data as Story;
  //
  //   return _buildStoryRow(context, story, index);
  //   } else if (snapshot.hasError) {
  //   print('error id = $storyId: ${snapshot.error}');
  //   return Container();
  //   } else {
  //   return FadeLoading();
  //   }
  //   },
  //   ),
  //   );
  //   }
  //   },
  //   );
  //   }
  //
  //   Widget _buildStoryRow(BuildContext context, Story story, int index) {
  //   return Dismissible(
  //   key: ValueKey(story.id),
  //   background: Container(
  //   color: Colors.green[700],
  //   padding: EdgeInsets.all(12.0),
  //   child: Row(
  //   children: [
  //   Center(
  //   child: Text(
  //   FlutterI18n.translate(context, 'app.action.read_later'),
  //   style: TextStyle(
  //   color: Colors.black54, fontWeight: FontWeight.bold),
  //   ),
  //   ),
  //   Flexible(
  //   child: Container(),
  //   ),
  //   ],
  //   ),
  //   ),
  //   onDismissed: (direction) {
  //   BlocProvider.of<StoriesBloc>(context).add(SaveStory(story, index));
  //   // repository.saveStory(story);
  //   Scaffold.of(context)
  //   ..hideCurrentSnackBar()
  //   ..showSnackBar(
  //   SnackBar(
  //   content: Text(
  //   FlutterI18n.translate(context, 'app.message.story_saved'),
  //   ),
  //   action: SnackBarAction(
  //   label: FlutterI18n.translate(context, 'app.action.undo')
  //       .toUpperCase(),
  //   onPressed: () => BlocProvider.of<StoriesBloc>(context)
  //       .add(UnSaveStory(story, index)),
  //   // repository.unsaveStory(index, story),
  //   ),
  //   ),
  //   );
  //   },
  //   child: StoryRow(
  //   story: story,
  //   ),
  //   );
  //   }
  //   }
  Widget _buildStoryRows(BuildContext context, int index) {
    return Center(
      child: Text('$index'),
    );
  }
}
