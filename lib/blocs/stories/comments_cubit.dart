import 'dart:async';

import 'package:hknews_repository/hknews_repository.dart';

import '../network/network_cubit.dart';

class CommentsCubit extends NetworkCubit<List<Item>> {
  final StoriesRepository _repository;

  int _itemId;

  CommentsCubit(this._repository)
      : assert(_repository != null),
        super();

  Future<void> getComments(int itemId) async {
    this._itemId = itemId;

    emit(NetworkState.loading());
    await _getComments(itemId);
  }

  @override
  Future<void> refresh() => _getComments(_itemId, fresh: true);

  Future<void> _getComments(int itemId, {bool fresh = false}) async {
    try {
      final latestItem = await _repository.getItem(_itemId, refresh: fresh);
      final itemStream = _repository.getComments(latestItem);
      emit(
        NetworkState.success(
          await itemStream.where((e) => !e.deleted && e.text != null).toList(),
        ),
      );
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }
}
