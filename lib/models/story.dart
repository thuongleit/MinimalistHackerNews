import 'package:hacker_news/models/copyable.dart';

import '../utils/const.dart';

enum StoryType { news, top, best, ask, show, jobs }

class Story with Copyable<Story> {
  static final dbSavedStoriesTableName = 'saved_stories';
  static final dbKeyId = 'id';
  static final dbKeyTitle = 'title';
  static final dbKeyBy = 'by';
  static final dbKeyDeleted = 'deleted';
  static final dbKeyTime = 'time';
  static final dbKeyType = 'type';
  static final dbKeyUrl = 'url';
  static final dbKeyText = 'text';
  static final dbKeyScore = 'score';
  static final dbKeyDescendants = 'descendants';
  static final dbKeyUpdatedAt = 'updated_at';
  static final dbKeyVisited = 'visited';

  final int id;
  final String title;
  final String by;
  final bool deleted;
  final int time;
  final String type;
  final String url;
  final String text;
  final int score;
  final int descendants;
  final int updatedAt;
  final bool visited;

  String get contentUrl => getRightUrl(Const.itemContentUrl, '$id');

  String get voteUrl => getRightUrl(Const.itemVoteUrl, '$id');

  const Story({
    this.id,
    this.title,
    this.by,
    this.deleted,
    this.time,
    this.type,
    this.url,
    this.text,
    this.score,
    this.descendants,
    this.updatedAt,
    this.visited,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      by: json['by'],
      deleted: json['deleted'] ?? false,
      time: json['time'],
      type: json['type'],
      url: json['url'] ?? '',
      text: json['text'],
      score: json['score'],
      descendants: json['descendants'] ?? 0,
      updatedAt: null,
      visited: false,
    );
  }

  factory Story.fromDb(Map<String, dynamic> result) {
    return Story(
      id: result[dbKeyId],
      title: result[dbKeyTitle],
      by: result[dbKeyBy],
      deleted: (result[dbKeyDeleted] == 1),
      time: result[dbKeyTime],
      type: result[dbKeyType],
      url: result[dbKeyUrl],
      text: result[dbKeyText],
      score: result[dbKeyScore],
      descendants: result[dbKeyDescendants],
      updatedAt: result[dbKeyUpdatedAt],
      visited: (result[dbKeyVisited] == 1),
    );
  }

  @override
  Story copy() {
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

  @override
  Story copyWith({int updatedAt, bool visited}) {
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
      updatedAt: updatedAt,
      visited: visited,
    );
  }
}
