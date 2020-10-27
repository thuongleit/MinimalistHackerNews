import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../widgets/index.dart';
import '../../repositories/index.dart';
import '../../utils/menu.dart';
import '../../services/api.dart';
import '../../database/index.dart';
import '../../models/index.dart';

class SavedStoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                SavedStoriesRepository(StoryDao.get(), ApiService.get()))
      ],
      child: Consumer<SavedStoriesRepository>(
        builder: (context, repository, child) => Scaffold(
          body: SliverPage<SavedStoriesRepository>.display(
            controller: null,
            title: FlutterI18n.translate(context, 'app.menu.saved_stories'),
            opacity: null,
            counter: null,
            slides: null,
            popupMenu: Menu.home,
            enablePullToRefresh: false,
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
      ),
    );
  }

  Widget _buildStoryRows(BuildContext context, int index) {
    return Consumer<SavedStoriesRepository>(
        builder: (context, repository, child) {
      final storyId = repository.storyIds[index];

      return Container(
          child: (repository.stories[storyId] != null)
              ? _buildStoryRow(
                  context, repository, index, repository.stories[storyId].left)
              : FutureBuilder(
                  future: repository.getStory(storyId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      var story = snapshot.data as Story;

                      return _buildStoryRow(context, repository, index, story);
                    } else if (snapshot.hasError) {
                      print('error id = $storyId: ${snapshot.error}');
                      return Container();
                    } else {
                      return FadeLoading();
                    }
                  }));
    });
  }

  Widget _buildStoryRow(BuildContext context, SavedStoriesRepository repository,
      int index, Story story) {
    return Dismissible(
      key: ValueKey(story.id),
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Center(
                child: Text(
              FlutterI18n.translate(context, 'app.action.delete'),
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
        repository.unsaveStory(story);
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(FlutterI18n.translate(context, 'screen.saved_stories.story_unsaved')),
              action: SnackBarAction(
                label: FlutterI18n.translate(context, 'app.action.undo'),
                onPressed: () {
                  repository.saveStory(index, story);
                },
              ),
            ),
          );
      },
      child: StoryRow(
        story: story,
        onItemTap: (story) => repository.visitStory(story),
      ),
    );
  }
}