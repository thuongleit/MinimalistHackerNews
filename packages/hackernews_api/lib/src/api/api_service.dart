import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import '../../hackernews_api.dart';
import '../const.dart';
import 'api_exception.dart';

abstract class HackerNewsApiClient {
  Future<List<int>> getItemIds(StoryType type);

  Future<Item> getItem(int itemId);

  Future<LoginResult> logIn(String username, String password);

  Future<User> getUser(String userId);
}

/// Serves data to several data repositories.
///
/// Makes http calls to several services, including
/// the open source r/HackerNews REST API.
class HackerNewsApiClientImpl extends HackerNewsApiClient {
  static RegExp _validationRequired = RegExp(r"Validation required");

  final Client _client;

  HackerNewsApiClientImpl({Client client}) : this._client = client ?? Client();

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
  Future<LoginResult> logIn(String username, String password) async {
    assert(username != null);
    assert(password != null);

    final url = '${Const.hackerNewsStoryBaseUrl}/login';

    Map body = {
      'acct': username,
      'pw': password,
      'goto': 'news',
    };
    final response = await _client.post(url, body: body);
    print('${response.statusCode} - ${response.body}');

    // If we get a 302 we assume it's successful
    if (response.statusCode == 302) {
      return LoginResult.success();
    } else if (_validationRequired.hasMatch(response.body)) {
      return LoginResult.failure(
        message: 'Login failed due to Captcha. Please try again later!',
      );
    } else {
      return LoginResult.failure(
        message: 'Login failed. Did you mistype your username and password?',
      );
    }
  }

  @override
  Future<User> getUser(String userId) async {
    assert(userId != null);
    // Receives the data and parse it
    String url = '${Const.hackerNewsApiEndpoint}/user/$userId.json';
    final response = await _client.get(Request(url));
    return User.fromJson(jsonDecode(response.body));
  }

  Future<String> _get(Request request, {String errorMessage}) async {
    final response = await _client.get(request.url);
    print('[GET] ${request.url}');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw HackerNewsApiException(message: errorMessage);
    }
  }

  Future<String> _post(Request request, {String errorMessage}) async {
    final response = await _client.post(request.url, body: request.body);
    print('[POST] ${request.url}:${request.body}');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw HackerNewsApiException(message: errorMessage);
    }
  }
}

class Request {
  final String url;
  final dynamic body;

  const Request(this.url, {this.body});
}

class LoginResult {
  final bool success;
  final String message;

  const LoginResult._({this.success, this.message});

  const LoginResult.success() : this._(success: true);

  const LoginResult.failure({String message})
      : this._(success: false, message: message);
}
