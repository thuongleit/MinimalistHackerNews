import 'dart:async';

import 'package:hknews_repository/hknews_repository.dart';

import '../network/network_cubit.dart';

class CommentCubit extends NetworkCubit<List<Item>> {
  final StoriesRepository _repository;

  CommentCubit(this._repository) : assert(_repository != null);

  Future<void> getComments(Item parent) async {
    emit(NetworkState.loading());
    try {
      final stream = _repository.getComments(parent);
      emit(NetworkState.success(await stream.toList()));
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }
}
