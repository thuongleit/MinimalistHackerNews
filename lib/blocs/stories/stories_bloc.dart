import 'package:flutter/foundation.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../blocs.dart';

part 'stories_event.dart';

class StoriesBloc extends NetworkBloc<StoriesEvent> {
  final StoriesRepository repository;

  StoriesBloc({@required this.repository})
      : assert(repository != null),
        super();

  @override
  Stream<NetworkState> mapEventToState(NetworkEvent event) async* {
    if (event is LoadStories) {
      yield* _mapLoadStoriesToState(event);
    }
  }

  Stream<NetworkState> _mapLoadStoriesToState(LoadStories event) async* {
    try {
      var storyIds = await repository.getStoryIds(event.type);
      yield NetworkState.success(storyIds);
    } on Exception catch (e) {
      yield NetworkState.failure(exception: e);
    }
  }
}
