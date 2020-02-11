class Item {
  static final String BROWSER_URL = 'https://news.ycombinator.com';

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
  List<Item> comments = List();

  Item(
      {this.id,
      this.title,
      this.by,
      this.deleted,
      this.time,
      this.type,
      this.url,
      this.text,
      this.score,
      this.descendants,
      this.kids});

  String getVoteUrl() => '$BROWSER_URL/vote?id=$id&how=up';

  String getContentUrl() => '$BROWSER_URL/item?id=$id';

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      title: json['title'],
      by: json['by'],
      deleted: json['deleted'],
      time: json['time'],
      type: json['type'],
      url: json['url'],
      text: json['text'],
      score: json['score'],
      descendants: json['descendants'],
      kids: json['kids'],
    );
  }
}

enum StoryType { NEW, TOP, BEST, ASK, SHOW, JOB }
