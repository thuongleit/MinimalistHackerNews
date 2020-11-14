import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import '../../utils/menu.dart';

class SavedStoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

// @override
// Widget build(BuildContext context) {
//   final screenTitle =
//       FlutterI18n.translate(context, 'app.menu.saved_stories');
//   return MultiProvider(
//     providers: [
//       ChangeNotifierProvider(
//           create: (_) =>
//               SavedStoriesRepository(StoryDao.get(), ApiService.get()))
//     ],
//     child: Consumer<SavedStoriesRepository>(
//       builder: (context, repository, child) => (repository
//               .storyIds.isNotEmpty)
//           ? Scaffold(
//               body: SliverPage<SavedStoriesRepository>.display(
//                 controller: null,
//                 title: screenTitle,
//                 opacity: null,
//                 counter: null,
//                 slides: null,
//                 popupMenu: Menu.home,
//                 enablePullToRefresh: false,
//                 body: <Widget>[
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       _buildStoryRows,
//                       childCount: repository.storyIds.length,
//                     ),
//                   )
//                 ],
//               ),
//             )
//           : SimplePage(
//               title: screenTitle,
//               body: BigTip(
//                 title: Text(
//                   FlutterI18n.translate(context,
//                       'screen.saved_stories.hint_message.no_saved_stories_title'),
//                 ),
//                 subtitle: Text(
//                   FlutterI18n.translate(context,
//                       'screen.saved_stories.hint_message.swipe_to_save'),
//                 ),
//                 action: Text(
//                   FlutterI18n.translate(
//                       context, 'screen.saved_stories.hint_message.action'),
//                 ),
//                 actionCallback: () => Navigator.pop(context),
//                 child: Icon(Icons.swipe),
//               ),
//             ),
//     ),
//   );
// }
//
// Widget _buildStoryRows(BuildContext context, int index) {
//   return Consumer<SavedStoriesRepository>(
//     builder: (context, repository, child) {
//       final storyId = repository.storyIds[index];
//
//       return Container(
//         child: (repository.stories[storyId] != null)
//             ? _buildStoryRow(
//                 context, repository, index, repository.stories[storyId].left)
//             : FutureBuilder(
//                 future: repository.getStory(storyId),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData && snapshot.data != null) {
//                     var story = snapshot.data as Story;
//
//                     return _buildStoryRow(context, repository, index, story);
//                   } else if (snapshot.hasError) {
//                     print('error id = $storyId: ${snapshot.error}');
//                     return Container();
//                   } else {
//                     return FadeLoading();
//                   }
//                 },
//               ),
//       );
//     },
//   );
// }
//
// Widget _buildStoryRow(BuildContext context, SavedStoriesRepository repository,
//     int index, Story story) {
//   return Dismissible(
//     key: ValueKey(story.id),
//     background: Container(
//       color: Colors.red,
//       padding: EdgeInsets.all(12.0),
//       child: Row(
//         children: [
//           Center(
//             child: Text(
//               FlutterI18n.translate(context, 'app.action.delete'),
//               style: TextStyle(
//                   color: Colors.black54, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Flexible(
//             child: Container(),
//           ),
//         ],
//       ),
//     ),
//     onDismissed: (direction) {
//       repository.unsaveStory(story);
//       Scaffold.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           SnackBar(
//             content: Text(
//               FlutterI18n.translate(
//                   context, 'screen.saved_stories.story_unsaved'),
//             ),
//             action: SnackBarAction(
//               label: FlutterI18n.translate(context, 'app.action.undo'),
//               onPressed: () {
//                 repository.saveStory(index, story);
//               },
//             ),
//           ),
//         );
//     },
//     child: StoryRow(
//       story: story,
//       onItemTap: (story) => repository.visitStory(story),
//     ),
//   );
// }
}
