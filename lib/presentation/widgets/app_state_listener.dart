import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../blocs/blocs.dart';
import '../../utils/utils.dart' as utils;

class AppStateListener extends StatelessWidget {
  const AppStateListener({this.child, Key key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previous, current) =>
              previous.status != Authentication.unknown,
          listener: (context, state) {
            if (state.status == Authentication.authenticated) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('User login'),
                  ),
                );
            } else {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('User logout'),
                  ),
                );
            }
          },
        ),
        BlocListener<UserActionBloc, UserActionState>(
          listenWhen: (previous, current) => current is UserActionResult,
          listener: (context, state) {
            if (state is UserNotFound) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('User not logged in'),
                    action: SnackBarAction(
                      label: 'Log in'.toUpperCase(),
                      onPressed: () => utils.Dialog.showLoginDialog(context),
                    ),
                  ),
                );
            } else if (state is UserActionResult) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
