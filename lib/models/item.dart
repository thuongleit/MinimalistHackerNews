import '../utils/url.dart';

enum StoryType { NEW, TOP, BEST, ASK, SHOW, JOB }

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
  final List<dynamic> kids;

  String get contentUrl => getRightUrl(Url.itemContentUrl, '$id');

  String get voteUrl => getRightUrl(Url.itemVoteUrl, '$id');

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
    this.kids,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      by: json['by'],
      deleted: json['deleted'],
      time: json['time'],
      type: json['type'],
      url: json['url'],
      text: json['text'],
      score: json['score'],
      descendants: json['descendants'] ?? 0,
      kids: json['kids'],
    );
  }
}
