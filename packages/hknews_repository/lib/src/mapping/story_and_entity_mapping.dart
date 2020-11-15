import 'package:hknews_database/hknews_database.dart';

import '../../src/models/story.dart';

extension StoryToStoryEntity on Story {
  StoryEntity toEntity() {
    return StoryEntity(
      id: this.id,
      title: this.title,
      by: this.by,
      deleted: this.deleted,
      time: this.time,
      type: this.type,
      url: this.url,
      text: this.text,
      score: this.score,
      descendants: this.descendants,
      updatedAt: this.updatedAt,
      visited: this.visited,
    );
  }
}

extension StoryEntityToStory on StoryEntity {
  Story toStory() {
    return Story(
      id: this.id,
      title: this.title,
      by: this.by,
      deleted: this.deleted,
      time: this.time,
      type: this.type,
      url: this.url,
      text: this.text,
      score: this.score,
      descendants: this.descendants,
      updatedAt: this.updatedAt,
      visited: this.visited,
    );
  }
}
