import 'package:hknews_repository/hknews_repository.dart';

import '../../blocs/network/network_cubit.dart';

class StoriesCubit extends NetworkCubit<List<int>> {
  final StoriesRepository _repository;

  StoryType _type;

  StoriesCubit(this._repository)
      : assert(_repository != null),
        super();

  Future<void> getStories(StoryType type) async {
    this._type = type;

    emit(NetworkState.loading());
    await _getStoryIds(type);
  }

  @override
  Future<void> refresh() => _getStoryIds(_type);

  Future<void> _getStoryIds(StoryType type) async {
    try {
      final storyIds = await _repository.getItemIds(type);
      emit(NetworkState.success(storyIds));
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }
}
