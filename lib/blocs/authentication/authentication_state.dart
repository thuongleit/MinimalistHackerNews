part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final String userId;
  final Authentication status;

  const AuthenticationState._({
    this.userId,
    this.status = Authentication.unauthenticated,
  });

  const AuthenticationState.authenticated(String userId)
      : this._(status: Authentication.authenticated, userId: userId);

  const AuthenticationState.unauthenticated()
      : this._(status: Authentication.unauthenticated);

  @override
  List<Object> get props => [status, userId];
}
