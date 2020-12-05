import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../blocs/blocs.dart';
import '../presentation/widgets/widgets.dart';

class Dialog {
  static Future<dynamic> showLoginDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Login with HackerNews'),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: BlocProvider<LoginBloc>(
              create: (context) {
                return LoginBloc(
                  authenticationRepository:
                      RepositoryProvider.of<AuthenticationRepository>(context),
                );
              },
              child: LoginForm(),
            ),
          ),
        ],
      ),
    );
  }

  static Future<dynamic> showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Are you sure to logout?'),
        ),
        actions: [
          TextButton(
            key: const ValueKey('logout_dialog_ok_button'),
            onPressed: () {
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
          TextButton(
            key: const ValueKey('logout_dialog_cancel_button'),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
