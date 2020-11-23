import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hacker_news/blocs/blocs.dart';
import 'package:hacker_news/presentation/widgets/login_form.dart';
import 'package:hknews_repository/hknews_repository.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) {
            return LoginBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            );
          },
          child: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (_, state) {
              if (state.status.isAuthenticated) {
                Navigator.of(context).pop();
              } else {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Authentication Failure')),
                  );
              }
            },
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
