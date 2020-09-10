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
          title: '',
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
      // builder: (context, model, child) {
      //   if (model.loadingFailed) {
      //     return ErrorHt(error: '');
      //   } else if (model.isLoading) {
      //     return LoadingIndicator();
      //   } else if (model.isLoaded) {
      //     return RefreshIndicator(
      //       key: _refreshIndicatorKey,
      //       child: ListView.builder(
      //         controller: scrollController,
      //         itemCount: model.storyIds.length,
      //         itemBuilder: (BuildContext context, int position) {
      //           var storyId = model.storyIds[position];
      //           return FutureBuilder(
      //             future: ApiService.getStory(storyId),
      //             builder: (BuildContext context, AsyncSnapshot snapshot) {
      //               if (model.stories[storyId] != null) {
      //                 var story = model.stories[storyId];
      //                 return StoryRow(
      //                   key: Key(storyId.toString()),
      //                   story: story,
      //                 );
      //               }
      //
      //               if (snapshot.hasData && snapshot.data != null) {
      //                 if (snapshot.data != null) {
      //                   var responseData = snapshot.data as Response;
      //                   var story = Story.fromJson(responseData.data);
      //                   model.stories[storyId] = story;
      //                   return StoryRow(
      //                     key: Key(storyId.toString()),
      //                     story: story,
      //                   );
      //                 } else {
      //                   print('item is null $position and id = $storyId');
      //                   return Container();
      //                 }
      //               } else if (snapshot.hasError) {
      //                 print('error $position and id = $storyId');
      //                 return Container();
      //               } else {
      //                 return FadeLoading();
      //               }
      //             },
      //           );
      //         },
      //       ),
      //       onRefresh: () => _onRefresh(context, model),
      //     );
      //   } else {
      //     return Container();
      //   }
      // },
      // builder: (context, value, child) => SliverPage<StoriesRepository>.display(
      //   controller: scrollController,
      //   title: "abc",
      //   opacity: null,
      //   counter: null,
      //   slides: null,
      //   body: <Widget>[
      //     FutureBuilder(
      //       future: ,
      //       stream: value.storiesStream,
      //       builder: (context, snapshot) => SliverList(
      //         delegate: SliverChildBuilderDelegate(
      //           (context, index) => StoryRow(
      //             key: UniqueKey(),
      //             story: snapshot.data as Story,
      //           ),
      //           childCount: value.storyIds.length,
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }

// /// Function which handles reloading [QueryModel] models.
// Future<void> _onRefresh(BuildContext context, BaseRepository repository) {
//   final Completer<void> completer = Completer<void>();
//
//   repository.refreshData().then((_) {
//     if (repository.loadingFailed) {
//       Scaffold.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           SnackBar(
//             content: Text(FlutterI18n.translate(
//               context,
//               'spacex.other.loading_error.message',
//             )),
//             action: SnackBarAction(
//               label: FlutterI18n.translate(
//                 context,
//                 'spacex.other.loading_error.reload',
//               ),
//               onPressed: () => _onRefresh(context, repository),
//             ),
//           ),
//         );
//     }
//     completer.complete();
//   });
//
//   return completer.future;
// }

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
