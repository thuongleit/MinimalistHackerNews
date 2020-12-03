import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';

import '../../blocs/user_input/input_field.dart';
import '../blocs.dart';

part 'user_input_event.dart';

part 'user_input_state.dart';

class UserInputBloc extends Bloc<UserInputEvent, UserInputState> {
  UserInputBloc({
    @required this.userAction,
  }) : super(const UserInputState());

  final UserActionBloc userAction;

  @override
  Stream<UserInputState> mapEventToState(UserInputEvent event) async* {
    print('map state $event');
    if (event is UserInputChanged) {
      yield _mapInputChangedToState(event, state);
    } else if (event is UserInputSubmitted) {
      yield* _mapInputSubmittedToState(event, state);
    }
  }

  UserInputState _mapInputChangedToState(
    UserInputChanged event,
    UserInputState state,
  ) {
    final inputValue = InputField.dirty(event.value);
    final status = state.copyWith(
      value: inputValue,
      status: Formz.validate([inputValue]),
    );
    return status;
  }

  Stream<UserInputState> _mapInputSubmittedToState(
    UserInputSubmitted event,
    UserInputState state,
  ) async* {
    if (state.status.isValid) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        userAction.add(event.action);
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (e) {
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.toString(),
        );
      }
    } else {
      final inputValue = InputField.dirty();
      yield state.copyWith(
        value: inputValue,
        status: FormzStatus.submissionFailure,
        message: '',
      );
    }
  }
}

extension UserInputBlocX on UserInputBloc {
  void input(String value) => add(UserInputChanged(value));
  void replyToComment(int itemId) => add(
        UserInputSubmitted(
          UserReplyToCommentRequested(
            itemId,
            state.input.value,
          ),
        ),
      );
}
