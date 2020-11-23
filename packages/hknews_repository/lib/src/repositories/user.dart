import 'dart:async';

import 'package:hackernews_api/hackernews_api.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:meta/meta.dart';

abstract class UserRepository {
  Future<User> getUser(String userId);

  Future<User> getCurrentUser();
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
}
