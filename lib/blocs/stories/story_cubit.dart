import 'dart:async';

import 'package:hknews_repository/hknews_repository.dart';

import '../network/network_cubit.dart';

class StoryCubit extends NetworkCubit<Item> {
  final StoriesRepository _repository;

  int _storyId;
  bool _contentPreview;

  StoryCubit(this._repository) : assert(_repository != null);

  Future<void> getStory(int storyId, {bool contentPreview = false}) async {
    this._storyId = storyId;
    this._contentPreview = contentPreview;

    if (!await _repository.hasItem(storyId)) {
      emit(NetworkState.loading());
    }
    await _getStory(storyId, contentPreview);
  }

  @override
  Future<void> refresh() => _getStory(_storyId, _contentPreview);

  Future _getStory(int storyId, bool contentPreview) async {
    try {
      final story =
          await _repository.getItem(storyId, previewContent: contentPreview);

      if (story.deleted) {
        emit(NetworkState.failure());
      } else {
        emit(NetworkState.success(story));
      }
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }
}
