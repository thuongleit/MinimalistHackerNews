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
  final UserActionEvent event;
  final dynamic error;
  final String message;

  const UserActionResult._({
    this.success,
    @required this.event,
    this.error,
    this.message,
  });

  const UserActionResult.success(
      {@required UserActionEvent event, String message})
      : this._(success: true, event: event, message: message);

  const UserActionResult.failure(
      {@required UserActionEvent event, dynamic error, String message})
      : this._(success: false, event: event, error: error, message: message);

  @override
  List<Object> get props => [event, error];
}
