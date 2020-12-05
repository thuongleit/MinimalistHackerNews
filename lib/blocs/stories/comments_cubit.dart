import 'dart:async';

import 'package:hknews_repository/hknews_repository.dart';

import '../network/network_cubit.dart';

class CommentCubit extends NetworkCubit<List<Item>> {
  final StoriesRepository _repository;

  Item _item;

  CommentCubit(this._repository)
      : assert(_repository != null),
        super();

  Future<void> getComments(Item item) async {
    this._item = item;

    emit(NetworkState.loading());
    await _getComments(item);
  }

  @override
  Future<void> refresh() => _getComments(_item);

  Future<void> _getComments(Item item) async {
    try {
      final stream = _repository.getComments(item);
      emit(
        NetworkState.success(
          await stream
              .where((e) => !(e.deleted && e.dead) && e.text != null)
              .toList(),
        ),
      );
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }
}
