import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:meta/meta.dart';

part 'user_action_event.dart';

part 'user_action_state.dart';

typedef Future<Result> Action();

class UserActionBloc extends Bloc<UserActionEvent, UserActionState> {
  UserActionBloc({
    @required UserRepository userRepository,
    @required StoriesRepository storiesRepository,
  })  : assert(userRepository != null),
        assert(storiesRepository != null),
        _userRepository = userRepository,
        _storiesRepository = storiesRepository,
        super(const UserActionInitial());

  final UserRepository _userRepository;
  final StoriesRepository _storiesRepository;

  @override
  Stream<UserActionState> mapEventToState(UserActionEvent event) async* {
    if (event is UserVoteRequested) {
      yield* _mapUserRequestedToState(() => _userRepository.vote(event.itemId));
    } else if (event is UserSaveStoryRequested) {
      yield* _mapUserRequestedToState(
          () => _storiesRepository.saveStory(event.item));
    } else if (event is UserUnSaveStoryRequested) {
      yield* _mapUserRequestedToState(
          () => _storiesRepository.unsaveStory(event.item));
    } else if (event is UserUpdateVisitRequested) {
      yield* _mapUserRequestedToState(
          () => _storiesRepository.updateVisited(event.item));
    }
  }

  Stream<UserActionState> _mapUserRequestedToState(
    Action action,
  ) async* {
    yield const UserActionInProgress();

    try {
      final result = await action();

      if (result.success) {
        yield UserActionResult.success(message: result.message);
      } else {
        yield UserActionResult.failure(message: result.message);
      }
    } on Exception catch (e) {
      yield UserActionResult.failure(message: e.toString());
    }
  }
}
