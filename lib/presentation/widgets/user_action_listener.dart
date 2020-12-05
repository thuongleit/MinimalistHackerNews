import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../blocs/blocs.dart';
import '../../utils/utils.dart' as utils;

class UserActionListener extends StatelessWidget {
  const UserActionListener({
    this.child,
    this.callback,
    Key key,
  }) : super(key: key);

  final Widget child;
  final Function(UserActionResult) callback;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previous, current) =>
              previous.status != Authentication.unknown,
          listener: (_, state) {
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
          listener: (_, state) {
            if (ModalRoute.of(context).isCurrent) {
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
                callback?.call(state);
              }
            }
          },
        ),
      ],
      child: child,
    );
  }
}
