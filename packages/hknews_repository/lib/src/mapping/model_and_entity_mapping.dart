import 'package:hackernews_api/hackernews_api.dart';
import 'package:hknews_database/hknews_database.dart';

extension ModelToEntityMapping on Item {
  ItemEntity toEntity() {
    return ItemEntity(
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

extension EntityToModelMapping on ItemEntity {
  Item toModel() {
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
