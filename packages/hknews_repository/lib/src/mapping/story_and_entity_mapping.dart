import 'package:hknews_database/hknews_database.dart';

import '../../src/models/item.dart';

extension StoryToStoryEntity on Item {
  StoryEntity toEntity() {
    return StoryEntity(
      id: this.id,
      title: this.title,
      by: this.by,
      deleted: this.deleted,
      time: this.time,
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
  Item toStory() {
    return Item(
      id: this.id,
      title: this.title,
      by: this.by,
      deleted: this.deleted,
      time: this.time,
      url: this.url,
      text: this.text,
      score: this.score,
      descendants: this.descendants,
      updatedAt: this.updatedAt,
      visited: this.visited,
    );
  }
}
