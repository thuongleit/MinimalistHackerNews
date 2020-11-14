part of 'stories_bloc.dart';

abstract class StoriesEvent extends NetworkEvent {
  const StoriesEvent();

  @override
  List<Object> get props => [];
}

class LoadStories extends StoriesEvent {
  final StoryType type;

  LoadStories(this.type);

  @override
  List<Object> get props => [type];
}

class SaveStory extends StoriesEvent {
  final Story story;

  SaveStory(this.story, int index);

  @override
  List<Object> get props => [story];

  @override
  String toString() => 'SaveStory { story: $story }';
}

class UnSaveStory extends StoriesEvent {
  final Story story;

  UnSaveStory(this.story, int index);

  @override
  List<Object> get props => [story];

  @override
  String toString() => 'UnSaveStory { story: $story }';
}
