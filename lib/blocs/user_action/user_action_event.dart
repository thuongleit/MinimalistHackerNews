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

class UserSaveStoryRequested extends UserActionEvent {
  const UserSaveStoryRequested(this.item);

  final Item item;

  @override
  List<Object> get props => [item];
}

class UserUnSaveStoryRequested extends UserActionEvent {
  const UserUnSaveStoryRequested(this.item);

  final Item item;

  @override
  List<Object> get props => [item];
}

class UserUpdateVisitRequested extends UserActionEvent {
  const UserUpdateVisitRequested(this.item);

  final Item item;

  @override
  List<Object> get props => [item];
}
