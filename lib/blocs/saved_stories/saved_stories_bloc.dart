import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'saved_stories_event.dart';
part 'saved_stories_state.dart';

class SavedStoriesBloc extends Bloc<SavedStoriesEvent, SavedStoriesState> {
  SavedStoriesBloc() : super(SavedStoriesInitial());

  @override
  Stream<SavedStoriesState> mapEventToState(
    SavedStoriesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
