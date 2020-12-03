import 'dart:async';

import 'package:hackernews_api/hackernews_api.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:hknews_repository/src/result.dart';
import 'package:meta/meta.dart';

abstract class UserRepository {
  Future<User> getUser(String userId);

  Future<User> getCurrentUser();

  Future<Result> vote(int itemId);

  Future<Result> reply(int itemId, String content);
}

class UserRepositoryImpl extends UserRepository {
  final AuthenticationRepository _authRepository;
  final HackerNewsApiClient _apiClient;

  final _usersCache = <String, User>{};

  UserRepositoryImpl({
    @required AuthenticationRepository authenticationRepository,
    HackerNewsApiClient apiClient,
  })  : this._authRepository = authenticationRepository,
        this._apiClient = apiClient ?? HackerNewsApiClientImpl();

  @override
  Future<User> getUser(String userId) async {
    if (userId == null || userId.isEmpty) {
      return null;
    }
    if (_usersCache.containsKey(userId)) {
      return _usersCache[userId];
    } else {
      final response = await _apiClient.getUser(userId);
      return _usersCache[userId] = response;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    final currentUserId = await _authRepository.getCurrentUserId();
    return getUser(currentUserId);
  }

  @override
  Future<Result> vote(int itemId) async {
    final user = await _getUserCredential();
    //FIXME: unvote
    final response = await _apiClient.vote(
      user.username,
      user.password,
      itemId,
      upVote: true,
    );
    return response.getResult;
  }

  @override
  Future<Result> reply(int itemId, String content) async {
    final user = await _getUserCredential();
    //FIXME: unvote
    final response = await _apiClient.reply(
      user.username,
      user.password,
      itemId,
      content
    );
    return response.getResult;
  }

  Future<_UserCredential> _getUserCredential() async {
    final isUserLogin = await _authRepository.isAuthenticated();
    if (!isUserLogin) {
      // return Result.failure(message: 'You are not logged in.');
    }

    final userCredential = await _authRepository.userCredential;
    final username = userCredential[0];
    final password = userCredential[1];

    return _UserCredential(
      username: username,
      password: password,
    );
  }
}

class _UserCredential {
  _UserCredential({this.username, this.password});

  final String username;
  final String password;
}
