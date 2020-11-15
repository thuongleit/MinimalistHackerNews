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
      final storyIds = await _repository.getStoryIds(type);
      emit(NetworkState.success(storyIds));
    } on Exception catch (e) {
      emit(NetworkState.failure(error: e));
    }
  }

  void saveStory(Story story, int index) {}

  unSaveStory(Story story, int index) {}

  @override
  Future<void> refresh() async {
    if (this._type == null) {
      return;
    }
    return fetchStories(_type);
  }
}
