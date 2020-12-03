part of 'user_input_bloc.dart';

abstract class UserInputEvent extends Equatable {
  const UserInputEvent();

  @override
  List<Object> get props => [];
}

class UserInputChanged extends UserInputEvent {
  const UserInputChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class UserInputSubmitted extends UserInputEvent {
  const UserInputSubmitted(this.action);

  final UserActionEvent action;

  @override
  List<Object> get props => [action];
}