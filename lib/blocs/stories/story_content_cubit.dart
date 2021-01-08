import 'dart:async';

import 'package:hknews_repository/hknews_repository.dart';

import '../network/network_cubit.dart';
import '../../extensions/model/story_ext.dart';

class StoryContentCubit extends NetworkCubit<String> {
  final StoriesRepository _repository;

  StoryContentCubit(this._repository) : assert(_repository != null);

  Future<void> get(int itemId) async {
    try {
      final cachedItem = _repository.getCachedItem(itemId);
      if (cachedItem != null) {
        if (cachedItem?.text?.isNotEmpty ?? false) {
          emit(NetworkState.success(cachedItem?.textAsHtml ?? ''));
          return;
        }
      }
      emit(NetworkState.loading());
      final item = await _repository.getItem(itemId, requestContent: true);
      emit(NetworkState.success(item?.textAsHtml ?? ''));
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }
}
