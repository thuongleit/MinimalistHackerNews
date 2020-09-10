import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/index.dart';
import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../services/index.dart';
import '../../utils/menu.dart';

class StoriesTab<T extends StoriesRepository> extends StatelessWidget {
  final StoryType storyType;
  final ScrollController scrollController;

  StoriesTab operator <(Type type) => this;

  const StoriesTab({Key key, this.storyType, this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, repository, child) => Scaffold(
        body: SliverPage<T>.display(
          controller: scrollController,
          title: getStoryTitle(storyType),
          opacity: null,
          counter: null,
          slides: null,
          popupMenu: Menu.home,
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

  Widget _buildStoryRows(BuildContext context, int index) {
    return Consumer<T>(builder: (context, repository, child) {
      final storyId = repository.storyIds[index];

      if (repository.stories[storyId] != null) {
        return StoryRow(
          key: Key(storyId.toString()),
          story: repository.stories[storyId],
        );
      } else {
        return Container(
          child: FutureBuilder(
              future: ApiService.getStory(storyId),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data != null) {
                    var responseData = snapshot.data as Response;
                    var story = Story.fromJson(responseData.data);
                    repository.stories[storyId] = story;
                    return StoryRow(
                      key: Key(storyId.toString()),
                      story: story,
                    );
                  } else {
                    print('item is null $index and id = $storyId');
                    return Container();
                  }
                } else if (snapshot.hasError) {
                  print('error $index and id = $storyId');
                  return Container();
                } else {
                  return FadeLoading();
                }
              }),
        );
      }
    });
  }
}
