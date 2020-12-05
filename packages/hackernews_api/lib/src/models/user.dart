class User {
  final String id;
  final int delay;
  final int created;
  final int karma;
  final String about;
  final List<int> submitted;

  User({
    this.id,
    this.delay,
    this.created,
    this.karma,
    this.about,
    this.submitted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') || json['id'] == null) {
      return null;
    }
    return User(
      id: json['id'],
      delay: json['delay'] == null ? 0 : json['delay'],
      created: json['created'] == null ? 0 : json['created'],
      karma: json['karma'] == null ? 0 : json['karma'],
      about: json['about'] == null ? '' : json['about'],
      submitted: json['submitted'] == null
          ? []
          : List<int>.from(json['submitted'].map((e) => e)),
    );
  }
}
