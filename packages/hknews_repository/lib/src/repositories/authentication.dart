import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hackernews_api/hackernews_api.dart';
import 'package:dio/dio.dart';

import '../const.dart';

enum Authentication { unknown, authenticated, unauthenticated }

class UserAuthenticationStatus {
  final String message;
  final Authentication status;

  const UserAuthenticationStatus._({
    this.message,
    this.status = Authentication.unknown,
  });

  const UserAuthenticationStatus.unknown() : this._();

  const UserAuthenticationStatus.authenticated()
      : this._(status: Authentication.authenticated);

  const UserAuthenticationStatus.unauthenticated({String message})
      : this._(message: message, status: Authentication.authenticated);
}

extension UserAuthenticationX on UserAuthenticationStatus {
  bool get isAuthenticated => status == Authentication.authenticated;

  bool get isUnauthenticated => (status == Authentication.unauthenticated ||
      status == Authentication.unknown);
}

abstract class AuthenticationRepository {
  Stream<UserAuthenticationStatus> get status;

  Future<String> getCurrentUserId();

  Future<bool> isAuthenticated();

  Future<void> logIn(String username, String password);

  Future<void> logOut();

  void dispose();
}

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  static RegExp validationRequired = RegExp(r'Validation required');
  final _controller = StreamController<UserAuthenticationStatus>();

  final FlutterSecureStorage _secureStorage;
  final HackerNewsApiClient _remoteSource;

  AuthenticationRepositoryImpl(
      {FlutterSecureStorage secureStorage, HackerNewsApiClient remoteSource})
      : this._secureStorage = secureStorage ?? FlutterSecureStorage(),
        this._remoteSource = remoteSource ?? HackerNewsApiClient();

  @override
  Future<String> getCurrentUserId() async =>
      await _secureStorage.read(key: 'username');

  @override
  Stream<UserAuthenticationStatus> get status async* {
    yield UserAuthenticationStatus.authenticated();
    yield* _controller.stream;
  }

  @override
  Future<void> logIn(String username, String password) async {
    assert(username != null);
    assert(password != null);

    final url = '${Const.hackerNewsBaseUrl}/login';

    Map body = {
      'acct': username,
      'pw': password,
      'goto': 'news',
    };

    final Response response =
        await _remoteSource.post(Request(url, data: body));

    // If we get a 302 we assume it's successful
    if (response.statusCode == 302) {
      await _secureStorage.write(key: 'username', value: username);
      await _secureStorage.write(key: 'password', value: password);

      _controller.add(UserAuthenticationStatus.authenticated());
    } else if (validationRequired.hasMatch(response.data)) {
      // Validation required.
      _controller.add(UserAuthenticationStatus.unauthenticated(
        message: 'Login failed due to Captcha. Please try again later.',
      ));
    } else {
      _controller.add(UserAuthenticationStatus.unauthenticated(
        message: 'Login failed. Did you mistype your credentials?',
      ));
    }
  }

  @override
  Future<void> logOut() async {
    await _secureStorage.delete(key: 'username');
    await _secureStorage.delete(key: 'password');
    _controller
        .add(UserAuthenticationStatus.unauthenticated(message: 'User logout!'));
  }

  @override
  void dispose() => _controller.close();

  @override
  Future<bool> isAuthenticated() async {
    var username = await _secureStorage.read(key: 'username');
    return username != null;
  }
}
