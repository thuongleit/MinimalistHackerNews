import '../utils/const.dart';

enum StoryType { news, top, best, ask, show, jobs }

class Story {
  static final dbTableName = 'stories';
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
  static final dbKeyStoryType = 'story_type';

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
  final StoryType storyType;

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
    this.storyType,
  });

  factory Story.fromJson(Map<String, dynamic> json, {StoryType type}) {
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
      storyType: type,
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
      storyType: StoryType.values[result[dbKeyStoryType]],
    );
  }
}
