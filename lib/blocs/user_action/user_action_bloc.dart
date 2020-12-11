import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:meta/meta.dart';

part 'user_action_event.dart';

part 'user_action_state.dart';

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
      yield* _mapUserRequestedToState(
        event,
        () => _userRepository.vote(event.itemId),
      );
    } else if (event is UserSaveStoryRequested) {
      yield* _mapUserRequestedToState(
        event,
        () => _storiesRepository.save(event.item),
      );
    } else if (event is UserUnSaveStoryRequested) {
      yield* _mapUserRequestedToState(
        event,
        () => _storiesRepository.unsave(event.item),
      );
    } else if (event is UserUpdateVisitRequested) {
      yield* _mapUserRequestedToState(
        event,
        () => _storiesRepository.updateVisited(event.item),
      );
    } else if (event is UserReplyToCommentRequested) {
      yield* _mapUserRequestedToState(
        event,
        () => _userRepository.reply(event.itemId, event.content),
      );
    }
  }

  Stream<UserActionState> _mapUserRequestedToState(
    UserActionEvent event,
    Future<Result> Function() action,
  ) async* {
    yield const UserActionInProgress();

    try {
      final result = await action();

      if (result.success) {
        yield UserActionResult.success(event: event);
      } else {
        yield UserActionResult.failure(
          event: event,
          message: result.message,
        );
      }
    } catch (e) {
      yield UserActionResult.failure(
        event: event,
        error: e,
      );
    }
  }
}
