import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hackernews_api/hackernews_api.dart';

enum Authentication { unknown, authenticated, unauthenticated }

class AuthenticationStatus {
  final Authentication status;
  final String message;

  const AuthenticationStatus._({
    this.status = Authentication.unknown,
    this.message,
  });

  const AuthenticationStatus.unknown() : this._();

  const AuthenticationStatus.authenticated()
      : this._(status: Authentication.authenticated);

  const AuthenticationStatus.unauthenticated({String message})
      : this._(message: message, status: Authentication.unauthenticated);
}

extension AuthenticationStatusX on AuthenticationStatus {
  bool get isAuthenticated => status == Authentication.authenticated;

  bool get isUnauthenticated => (status == Authentication.unauthenticated ||
      status == Authentication.unknown);
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

  Future<AuthenticationStatus> logIn(String username, String password);

  Future<AuthenticationStatus> createAccount(String username, String password);

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
  Future<AuthenticationStatus> logIn(String username, String password) async {
    final response = await _apiClient.logIn(username, password);
    if (response.success) {
      await _secureStorage.write(
          key: AuthenticationRepository._keyUsername, value: username);
      await _secureStorage.write(
          key: AuthenticationRepository._keyPassword, value: password);

      _controller.add(Authentication.authenticated);
      return AuthenticationStatus.authenticated();
    } else {
      _controller.add(Authentication.unauthenticated);
      return AuthenticationStatus.unauthenticated(message: response.message);
    }
  }

  @override
  Future<AuthenticationStatus> createAccount(
      String username, String password) async {
    final response = await _apiClient.createAccount(username, password);
    if (response.success) {
      await _secureStorage.write(
          key: AuthenticationRepository._keyUsername, value: username);
      await _secureStorage.write(
          key: AuthenticationRepository._keyPassword, value: password);

      _controller.add(Authentication.authenticated);
      return AuthenticationStatus.authenticated();
    } else {
      _controller.add(Authentication.unauthenticated);
      return AuthenticationStatus.unauthenticated(message: response.message);
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
  Future<List<String>> get userCredential async {
    var userName =
        await _secureStorage.read(key: AuthenticationRepository._keyUsername);
    var password =
        await _secureStorage.read(key: AuthenticationRepository._keyPassword);
    return [userName, password];
  }
}
