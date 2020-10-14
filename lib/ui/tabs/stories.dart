import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../widgets/index.dart';
import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../utils/menu.dart';

class StoriesTab<T extends StoriesRepository> extends StatelessWidget {
  final StoryType storyType;
  final ScrollController scrollController;

  const StoriesTab({Key key, this.storyType, this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, repository, child) => Scaffold(
        body: SliverPage<T>.display(
          controller: scrollController,
          title: FlutterI18n.translate(context, getStoryTitleKey(storyType)),
          opacity: null,
          counter: null,
          slides: null,
          popupMenu: Menu.home,
          actions: Menu.home_actions
              .map((action) => _buildMenuAction(context, action))
              .toList(),
          body: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                _buildStoryRows,
                childCount: repository.storyIds.length,
              ),
            )
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

  Widget _buildStoryRows(BuildContext context, int index) {
    return Consumer<T>(builder: (context, repository, child) {
      final storyId = repository.storyIds[index];

      return Container(
          child: (repository.stories[storyId] != null)
              ? _buildStoryRow(context, repository, repository.stories[storyId])
              : FutureBuilder(
                  future: repository.getStory(storyId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      var story = snapshot.data as Story;

                      return _buildStoryRow(context, repository, story);
                    } else if (snapshot.hasError) {
                      print('error id = $storyId: ${snapshot.error}');
                      return Container();
                    } else {
                      return FadeLoading();
                    }
                  }));
    });
  }

  Widget _buildStoryRow(
      BuildContext context, StoriesRepository repository, Story story) {
    return Dismissible(
      key: ValueKey(story.id),
      background: Container(
        color: Colors.green[700],
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Center(
                child: Text(
              'Read it later',
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            )),
            Flexible(
              child: Container(),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        repository.saveStory(story);
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('Story is saved')));
      },
      child: StoryRow(
        story: story,
      ),
    );
  }
}
