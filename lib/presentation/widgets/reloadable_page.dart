import 'dart:async';

import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_fonts/google_fonts.dart';

import 'simple_page.dart';
import '../../blocs/blocs.dart';

class ReloadablePage<C extends NetworkCubit> extends StatelessWidget {
  final String title;
  final Widget body, fab;
  final List<Widget> actions;

  const ReloadablePage({
    @required this.title,
    @required this.body,
    this.fab,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: title,
      fab: fab,
      body: BlocConsumer<C, NetworkState>(
        listenWhen: (previous, current) => current.isFailure,
        listener: (context, state) => Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(FlutterI18n.translate(
                context,
                'app.message.loading.connection_error.message',
              )),
              action: SnackBarAction(
                label: FlutterI18n.translate(
                  context,
                  'app.message.loading.connection_error.reload',
                ),
                onPressed: () => context.read<C>().refresh(),
              ),
            ),
          ),
        builder: (context, state) => RefreshIndicator(
          onRefresh: () => context.read<C>().refresh(),
          child: _buildBody(context, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NetworkState<dynamic> state) {
    Scaffold.of(context)..hideCurrentSnackBar();
    if (state.isInitial) {
      return Container();
    } else if (state.isLoading) {
      return _loadingIndicator;
    } else if (state.isFailure) {
      return ConnectionError(
        onRefresh: () => context.read<C>().refresh(),
      );
    } else {
      return SafeArea(bottom: false, child: body);
    }
  }

  /// Centered [CircularProgressIndicator] widget.
  Widget get _loadingIndicator =>
      Center(child: const CircularProgressIndicator());
}

/// Widget used to display a connection error message.

/// It allows user to reload the page with a simple button.
class ConnectionError extends StatelessWidget {
  final ValueGetter<Future<void>> onRefresh;

  const ConnectionError({Key key, @required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BigTip(
      subtitle: Text(
        FlutterI18n.translate(
          context,
          'app.message.loading.connection_error.message',
        ),
        style:
            GoogleFonts.rubikTextTheme(Theme.of(context).textTheme).subtitle1,
      ),
      action: Text(
        FlutterI18n.translate(
          context,
          'app.message.loading.connection_error.reload',
        ),
        style: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
            .subtitle1
            .copyWith(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
      ),
      actionCallback: onRefresh,
      child: Icon(Icons.cloud_off),
    );
  }
}
