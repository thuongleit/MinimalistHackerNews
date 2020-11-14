part of 'saved_stories_bloc.dart';

abstract class SavedStoriesState extends Equatable {
  const SavedStoriesState();
}

class SavedStoriesInitial extends SavedStoriesState {
  @override
  List<Object> get props => [];
}
