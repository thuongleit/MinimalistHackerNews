import 'package:hknews_repository/src/utils/copyable.dart';

enum StoryType { news, top, best, ask, show, jobs }

enum ItemType { job, story, comment, poll, pollopt }

class Item with Copyable<Item> {
  int depth;
  final int id;
  final bool deleted;
  final ItemType type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final int poll;
  final List<int> kids;
  final String url;
  final int score;
  final String title;
  final List<int> parts;
  final int descendants;
  int updatedAt;
  bool visited;

  Item({
    this.depth = 0,
    this.id,
    this.deleted,
    this.type,
    this.by,
    this.time,
    this.text,
    this.dead,
    this.parent,
    this.poll,
    this.kids,
    this.url,
    this.score,
    this.title,
    this.parts,
    this.descendants,
    this.updatedAt,
    this.visited = false,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'],
        deleted: json['deleted'] == null ? false : json['deleted'],
        type: _castItemType(json['type']),
        by: json['by'],
        time: json['time'] == null ? 0 : json['time'],
        text: json['text'],
        dead: json['dead'] == null ? false : json['dead'],
        parent: json['parent'],
        poll: json['poll'],
        kids: json['kids'] == null
            ? []
            : List<int>.from(json['kids'].map((e) => e)),
        url: json['url'],
        score: json['score'] == null ? 0 : json['score'],
        title: json['title'],
        parts: json['parts'] == null
            ? []
            : List<int>.from(json['parts'].map((e) => e)),
        descendants: json['descendants'] == null ? 0 : json['descendants'],
      );

  @override
  Item copy() {
    return Item(
      depth: this.depth,
      id: this.id,
      deleted: this.deleted,
      type: this.type,
      by: this.by,
      time: this.time,
      text: this.text,
      dead: this.dead,
      parent: this.parent,
      poll: this.poll,
      kids: this.kids,
      url: this.url,
      score: this.score,
      title: this.title,
      parts: this.parts,
      descendants: this.descendants,
      updatedAt: this.updatedAt,
      visited: this.visited,
    );
  }

  @override
  Item copyWith({String text}) {
    return Item(
      depth: this.depth,
      id: this.id,
      deleted: this.deleted,
      type: this.type,
      by: this.by,
      time: this.time,
      text: text ?? this.text,
      dead: this.dead,
      parent: this.parent,
      poll: this.poll,
      kids: this.kids,
      url: this.url,
      score: this.score,
      title: this.title,
      parts: this.parts,
      descendants: this.descendants,
      updatedAt: this.updatedAt,
      visited: this.visited,
    );
  }

  static ItemType _castItemType(String value) {
    switch (value) {
      case 'job':
        return ItemType.job;
        break;
      case 'story':
        return ItemType.story;
        break;
      case 'comment':
        return ItemType.comment;
        break;
      case 'poll':
        return ItemType.poll;
        break;
      case 'pollopt':
        return ItemType.pollopt;
        break;
      default:
        return null;
        break;
    }
  }
}
