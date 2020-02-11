import 'package:firebase/firebase_io.dart';
import './../models/item.dart';
import 'dart:async';

class HackerNewsApi {
  static final String _API_ENDPOINT = 'https://hacker-news.firebaseio.com/v0/';

  FirebaseClient _client = FirebaseClient.anonymous();

  static final HackerNewsApi _singleton = HackerNewsApi._internal();

  HackerNewsApi._internal();

  factory HackerNewsApi() => _singleton;

  Future<List<dynamic>> fetchStories(StoryType type) async {
    var path = '';

    switch (type) {
      case StoryType.NEW:
        path = 'newstories';
        break;

      case StoryType.TOP:
        path = 'topstories';
        break;

      case StoryType.BEST:
        path = 'beststories';
        break;

      case StoryType.JOB:
        path = 'jobstories';
        break;

      case StoryType.SHOW:
        path = 'showstories';
        break;

      case StoryType.ASK:
        path = 'askstories';
        break;
    }

    var url = "$_API_ENDPOINT$path.json";
    print("request $url");
    return await _client.get(url);
  }

  Future<Item> getItem(int id) async {
    var url = "$_API_ENDPOINT/item/$id.json";
    var response = await _client.get(url);

    return Item.fromJson(response);
  }

  Future<List<Item>> getComments(Item item) async {
    if (item.kids.isEmpty) {
      return List();
    } else {
      var comments = await Future.wait(item.kids.map((id) => getItem(id)));

      var nestedComments =
          await Future.wait(comments.map((comment) => getComments(comment)));

      for (var i = 0; i < nestedComments.length; i++) {
        comments[i].comments = nestedComments[i];
      }

      return comments;
    }
  }
}
