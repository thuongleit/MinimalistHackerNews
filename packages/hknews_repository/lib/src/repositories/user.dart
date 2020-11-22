import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hackernews_api/hackernews_api.dart';
import 'package:dio/dio.dart';

import '../../src/models/user.dart';
import '../const.dart';

abstract class UserRepository {
  Future<User> getUser(String userId);
}

class UserRepositoryImpl extends UserRepository {
  final HackerNewsApiClient _remoteSource;
  final FlutterSecureStorage _secureStorage;

  final _usersCache = <String, User>{};

  UserRepositoryImpl(
      {FlutterSecureStorage secureStorage, HackerNewsApiClient remoteSource})
      : this._secureStorage = secureStorage ?? FlutterSecureStorage(),
        this._remoteSource = remoteSource ?? HackerNewsApiClient();

  @override
  Future<User> getUser(String userId) async {
    if (userId == null || userId.isEmpty) {
      return null;
    }
    if (_usersCache.containsKey(userId)) {
      return _usersCache[userId];
    } else {
      // Receives the data and parse it
      String url = '${Const.hackerNewsBaseUrl}/user/$userId.json';
      final Response response = await _remoteSource.get(Request(url));
      print('request $url');
      return _usersCache[userId] = User.fromJson(response.data);
    }
  }
}
