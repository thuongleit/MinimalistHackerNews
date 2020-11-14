import 'dart:async';

import 'package:hacker_news/blocs/blocs.dart';
import 'package:hknews_repository/hknews_repository.dart';

class StoryCubit extends NetworkCubit<Story> {
  final int storyId;
  final StoriesRepository repository;

  StoryCubit(this.storyId, this.repository)
      : assert(storyId != null),
        assert(repository != null);

  @override
  Future<void> fetchData() async {
    try {
      var story = await repository.getStory(storyId);

      emit(NetworkState.success(story));
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }
}
