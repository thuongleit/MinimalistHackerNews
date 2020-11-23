import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hackernews_api/hackernews_api.dart';

enum Authentication { authenticated, unauthenticated }

extension AuthenticationStatusX on Authentication {
  bool get isAuthenticated => index == 0;

  bool get isUnauthenticated => index == 1;
}

class AuthenticationStatus {
  final String message;
  final Authentication status;

  const AuthenticationStatus._({
    this.message,
    this.status = Authentication.unauthenticated,
  });

  const AuthenticationStatus.authenticated()
      : this._(status: Authentication.authenticated);

  const AuthenticationStatus.unauthenticated({String message})
      : this._(message: message, status: Authentication.authenticated);
}

abstract class AuthenticationRepository {
  AuthenticationRepository({FlutterSecureStorage secureStorage})
      : this._secureStorage = secureStorage ?? FlutterSecureStorage();

  static final _keyUsername = 'username';
  static final _keyPassword = 'password';

  final FlutterSecureStorage _secureStorage;

  Stream<Authentication> get status;

  Future<bool> isAuthenticated();

  Future<String> getCurrentUserId();

  Future<void> logIn(String username, String password);

  Future<void> logOut();

  void dispose();
}

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  AuthenticationRepositoryImpl({
    FlutterSecureStorage secureStorage,
    HackerNewsApiClient apiClient,
  })  : this._apiClient = apiClient ?? HackerNewsApiClientImpl(),
        super(secureStorage: secureStorage);

  final _controller = StreamController<Authentication>();
  final HackerNewsApiClient _apiClient;

  @override
  Stream<Authentication> get status async* {
    if (await isAuthenticated()) {
      yield Authentication.authenticated;
    } else {
      yield Authentication.unauthenticated;
    }
    yield* _controller.stream;
  }

  @override
  Future<void> logIn(String username, String password) async {
    try {
      final success = await _apiClient.logIn(username, password);
      // If we get a 302 we assume it's successful
      if (success) {
        await _secureStorage.write(
            key: AuthenticationRepository._keyUsername, value: username);
        await _secureStorage.write(
            key: AuthenticationRepository._keyPassword, value: password);

        _controller.add(Authentication.authenticated);
      } else {
        _controller.add(Authentication.unauthenticated);
      }
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<void> logOut() async {
    await _secureStorage.delete(key: AuthenticationRepository._keyUsername);
    await _secureStorage.delete(key: AuthenticationRepository._keyPassword);
    _controller.add(Authentication.unauthenticated);
  }

  @override
  Future<String> getCurrentUserId() async =>
      await _secureStorage.read(key: AuthenticationRepository._keyUsername);

  @override
  Future<bool> isAuthenticated() async {
    final username = await getCurrentUserId();
    return username != null;
  }

  @override
  void dispose() => _controller.close();
}

extension AuthenticationRepositoryX on AuthenticationRepository {
  Future<Map<String, String>> get userCredential async {
    var userName =
        await _secureStorage.read(key: AuthenticationRepository._keyUsername);
    var password =
        await _secureStorage.read(key: AuthenticationRepository._keyPassword);
    return {userName: password};
  }
}
