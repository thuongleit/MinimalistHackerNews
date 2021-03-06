import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../hackernews_api.dart';
import '../const.dart';
import 'api_exception.dart';

abstract class HackerNewsApiClient {
  Future<List<int>> getItemIds(StoryType type);

  Future<Item> getItem(int itemId);

  Future<Response> logIn(String username, String password);

  Future<Response> createAccount(String username, String password);

  Future<User> getUser(String userId);

  Future<Response> vote(
    String username,
    String password,
    int itemId, {
    bool upVote = true,
  });

  Future<Response> reply(
    String username,
    String password,
    int itemId,
    String content,
  );
}

/// Serves data to several data repositories.
///
/// the open source r/HackerNews REST API.
class HackerNewsApiClientImpl extends HackerNewsApiClient {
  static final RegExp _serverResponseMsgReg =
      RegExp(r"<body>\n*.*\n*<br>", multiLine: true);

  static final _requestUsernameKey = 'acct';
  static final _requestPasswordKey = 'pw';
  static final _requestActionKey = 'goto';

  final http.Client _client;

  HackerNewsApiClientImpl({http.Client client})
      : this._client = client ?? http.Client();

  @override
  Future<List<int>> getItemIds(StoryType type) async {
    final response = await _get(Request(type.url));
    return List<int>.from(jsonDecode(response));
  }

  @override
  Future<Item> getItem(int itemId) async {
    final requestUrl = '${Const.hackerNewsApiEndpoint}/item/$itemId.json';
    final response = await _get(Request(requestUrl));
    return Item.fromJson(jsonDecode(response));
  }

  @override
  Future<Response> logIn(String username, String password) async {
    assert(username != null);
    assert(password != null);

    final url = '${Const.hackerNewsStoryBaseUrl}/login';

    Map body = {
      _requestUsernameKey: username,
      _requestPasswordKey: password,
      _requestActionKey: 'user?id=$username',
    };
    return _handlePostResponse(await _client.post(url, body: body));
  }

  @override
  Future<Response> createAccount(String username, String password) async {
    assert(username != null);
    assert(password != null);

    final url = '${Const.hackerNewsStoryBaseUrl}/login';

    Map body = {
      'creating': 't',
      _requestUsernameKey: username,
      _requestPasswordKey: password,
      _requestActionKey: 'user?id=$username',
    };
    return _handlePostResponse(await _client.post(url, body: body));
  }

  @override
  Future<User> getUser(String userId) async {
    assert(userId != null);
    // Receives the data and parse it
    String url = '${Const.hackerNewsApiEndpoint}/user/$userId.json';
    final response = await _get(Request(url));
    return User.fromJson(jsonDecode(response));
  }

  @override
  Future<Response> vote(String username, String password, int itemId,
      {bool upVote = true}) async {
    assert(username != null);
    assert(password != null);
    assert(itemId != null);

    final url = '${Const.hackerNewsStoryBaseUrl}/vote';

    Map body = {
      _requestUsernameKey: username,
      _requestPasswordKey: password,
      _requestActionKey: 'user?id=$username',
      'id': '$itemId',
      'how': upVote ? 'up' : 'un',
    };
    return _handlePostResponse(await _client.post(url, body: body));
  }

  @override
  Future<Response> reply(
      String username, String password, int itemId, String content) async {
    assert(username != null);
    assert(password != null);
    assert(itemId != null);
    assert(content != null);

    final url = '${Const.hackerNewsStoryBaseUrl}/comment';
    //xedit is edit a reply

    Map body = {
      _requestUsernameKey: username,
      _requestPasswordKey: password,
      _requestActionKey: 'item?id=$itemId',
      'parent': '$itemId',
      'text': content
    };
    return _handlePostResponse(await _client.post(url, body: body));
  }

  Future<String> _get(Request request) async {
    final response = await _client.get(request.url);
    print('[GET] ${request.url}');
    if (response.statusCode == HttpStatus.ok) {
      return response.body;
    } else {
      throw HackerNewsApiException(
        errorCode: response.statusCode,
        message: response.body,
      );
    }
  }

  Response _handlePostResponse(http.Response response) {
    print('${response.statusCode} - ${response.body}');

    // If we get a 302 we assume it's successful
    if (response.statusCode == HttpStatus.found) {
      return Response.success();
    } else if (response.statusCode == HttpStatus.ok) {
      return Response.failure(
        message: _parseServerMessage(response.body),
      );
    } else {
      throw HackerNewsApiException(
        errorCode: response.statusCode,
        message: response.body,
      );
    }
  }

  String _parseServerMessage(String responseBody) {
    final serverMessage = _serverResponseMsgReg.stringMatch(responseBody);
    String redirectErrorMessage;
    if (serverMessage?.isEmpty ?? true) {
      redirectErrorMessage = 'Unknown server error.';
    } else if (serverMessage.contains('Bad login')) {
      redirectErrorMessage = 'Incorrect username or password.';
    } else if (serverMessage.contains('Validation required')) {
      redirectErrorMessage =
          'Validation required! You have been temporarily blocked for too many failed attempts by Hacker News. '
          'Please try again later or log in with a web browser.';
    } else {
      redirectErrorMessage = serverMessage;
    }

    return redirectErrorMessage;
  }
}

class Request {
  final String url;
  final dynamic body;

  const Request(this.url, {this.body});
}

class Response {
  final bool success;
  final String message;

  const Response._({this.success, this.message});

  const Response.success({String message})
      : this._(success: true, message: message);

  const Response.failure({String message})
      : this._(success: false, message: message);
}
