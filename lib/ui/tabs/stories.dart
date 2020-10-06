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
      return Container(child: repository.buildStoryWidget(storyType, storyId));
    });
  }
}
