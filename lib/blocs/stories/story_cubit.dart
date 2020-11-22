import 'dart:async';

import 'package:hknews_repository/hknews_repository.dart';

import '../network/network_cubit.dart';

class StoryCubit extends NetworkCubit<Item> {
  final StoriesRepository _repository;

  StoryCubit(this._repository) : assert(_repository != null);

  Future<void> getStory(int storyId, {bool contentPreview = false}) async {
    emit(NetworkState.loading());
    try {
      var story = await _repository.getStory(storyId, previewContent: contentPreview);

      emit(NetworkState.success(story));
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }
}
