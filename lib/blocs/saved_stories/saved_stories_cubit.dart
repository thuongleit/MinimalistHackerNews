import 'package:hknews_repository/hknews_repository.dart';

import '../../blocs/network/network_cubit.dart';

class SavedStoriesCubit extends NetworkCubit<List<Item>> {
  final StoriesRepository _repository;

  SavedStoriesCubit(this._repository)
      : assert(_repository != null),
        super();

  Future<void> getSavedStories() async {
    emit(NetworkState.loading());
    try {
      final stories = await _repository.getSavedItems();
      emit(NetworkState.success(stories));
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }
}
