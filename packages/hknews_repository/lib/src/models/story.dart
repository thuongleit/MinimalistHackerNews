enum StoryType { news, top, best, ask, show, jobs }

class Story {
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
}