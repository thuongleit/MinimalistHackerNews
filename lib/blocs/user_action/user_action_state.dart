part of 'user_action_bloc.dart';

abstract class UserActionState extends Equatable {
  const UserActionState();

  @override
  List<Object> get props => [];
}

class UserActionInitial extends UserActionState {
  const UserActionInitial() : super();
}

class UserActionInProgress extends UserActionState {
  const UserActionInProgress() : super();
}

class UserActionResult extends UserActionState {
  final bool success;
  final String message;

  const UserActionResult._({
    this.success,
    this.message,
  });

  const UserActionResult.success({String message})
      : this._(success: true, message: message);

  const UserActionResult.failure({String message})
      : this._(success: false, message: message);

  @override
  List<Object> get props => [success, message];
}

class UserNotFound extends UserActionResult {
  UserNotFound() : super.failure();
}
