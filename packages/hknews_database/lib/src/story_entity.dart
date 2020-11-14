class StoryEntity {
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

  const StoryEntity({
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

  factory StoryEntity.fromDatabase(Map<String, dynamic> result) {
    return StoryEntity(
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
}
