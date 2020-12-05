import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../blocs/blocs.dart';
import '../../const.dart';
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
              if (state is UserActionResult) {
                callback?.call(state);

                String message;
                SnackBarAction action;
                if (state.success) {
                  message = state.event.successMessage;
                } else {
                  if (state.error is UserNotFoundException) {
                    message = 'User not logged in';
                    action = SnackBarAction(
                      label: 'Log in'.toUpperCase(),
                      onPressed: () => utils.Dialog.showLoginDialog(context),
                    );
                  } else if (state.error is SocketException) {
                    message = 'No internet connection';
                  } else {
                    message = state.message ?? Const.generalErrorMessage;
                  }
                }
                if (message != null) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(message),
                        action: action,
                      ),
                    );
                }
              }
            }
          },
        ),
      ],
      child: child,
    );
  }
}

extension UserActionEventX on UserActionEvent {
  String get successMessage {
    if (this is UserVoteRequested) {
      return 'story voted';
    } else if (this is UserSaveStoryRequested) {
      return 'story saved';
    } else if (this is UserUnSaveStoryRequested) {
      return 'story unsaved';
    } else if (this is UserUpdateVisitRequested) {
      return null;
    } else if (this is UserReplyToCommentRequested) {
      return 'comment posted';
    } else {
      return 'unregistered user action';
    }
  }
}
