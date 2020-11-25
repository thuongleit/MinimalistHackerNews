import 'package:hknews_repository/hknews_repository.dart';

import '../../blocs/network/network_cubit.dart';

class StoriesCubit extends NetworkCubit<List<int>> {
  final StoriesRepository _repository;

  StoryType _type;

  StoriesCubit(this._repository)
      : assert(_repository != null),
        super();

  Future<void> fetchStories(StoryType type) async {
    assert(type != null);
    this._type = type;

    emit(NetworkState.loading());
    try {
      final storyIds = await _repository.getItemIds(type);
      emit(NetworkState.success(storyIds));
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }

  @override
  Future<void> refresh() async {
    if (this._type == null) {
      return;
    }
    return fetchStories(_type);
  }

}
