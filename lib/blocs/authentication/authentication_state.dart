part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final UserAuthenticationStatus status;
  final String user;

  const AuthenticationState._({
    this.status = const UserAuthenticationStatus.unknown(),
    this.user,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(String user)
      : this._(
            status: const UserAuthenticationStatus.authenticated(), user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: const UserAuthenticationStatus.unauthenticated());

  @override
  List<Object> get props => [status, user];
}
