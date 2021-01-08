import 'dart:async';

import 'package:hknews_repository/hknews_repository.dart';

import '../network/network_cubit.dart';

class StoryCubit extends NetworkCubit<Item> {
  final StoriesRepository _repository;

  int _storyId;

  StoryCubit(this._repository) : assert(_repository != null);

  Future<void> getStory(int itemId) async {
    this._storyId = itemId;

    await _getStory(itemId);
  }

  @override
  Future<void> refresh() => _getStory(_storyId, refresh: true);

  Future _getStory(int itemId, {bool refresh = false}) async {
    try {
      if (!refresh) {
        final cachedItem = _repository.getCachedItem(itemId);
        if (cachedItem != null) {
          _emit(cachedItem);
          return;
        }
      }
      emit(NetworkState.loading());
      final item = await _repository.getItem(itemId, refresh: refresh);
      _emit(item);
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }

  void _emit(Item item) {
    if (item != null && !item.deleted && !item.dead) {
      emit(NetworkState.success(item));
    } else {
      emit(NetworkState.failure());
    }
  }
}
