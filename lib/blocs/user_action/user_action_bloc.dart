import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:meta/meta.dart';

part 'user_action_event.dart';

part 'user_action_state.dart';

class UserActionBloc extends Bloc<UserActionEvent, UserActionState> {
  UserActionBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(const UserActionInitial());

  final UserRepository _userRepository;

  @override
  Stream<UserActionState> mapEventToState(UserActionEvent event) async* {
    if (event is UserVoteRequested) {
      yield* _mapUserVoteRequestedToState(event);
    }
  }

  Stream<UserActionState> _mapUserVoteRequestedToState(
      UserVoteRequested event) async* {
    yield const UserActionInProgress();

    try {
      final result = await _userRepository.vote(event.itemId);

      if (result.success) {
        yield UserActionResult.success();
      } else {
        yield UserActionResult.failure(message: result.message);
      }
    } on Exception catch (e) {
      yield UserActionResult.failure(message: e.toString());
    }
  }
}
