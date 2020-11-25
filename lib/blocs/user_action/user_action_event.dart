part of 'user_action_bloc.dart';

abstract class UserActionEvent extends Equatable {
  const UserActionEvent();

  @override
  List<Object> get props => [];
}

class UserVoteRequested extends UserActionEvent {
  const UserVoteRequested(this.itemId);

  final int itemId;

  @override
  List<Object> get props => [itemId];
}
