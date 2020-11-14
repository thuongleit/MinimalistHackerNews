import 'dart:async';

import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacker_news/blocs/blocs.dart';

import 'simple_page.dart';

/// Basic page which has reloading properties.
class ReloadablePage<B extends NetworkBloc> extends StatelessWidget {
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
      body: BlocConsumer<B, NetworkState>(
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
                onPressed: () => _onRefresh(context),
              ),
            ),
          ),
        builder: (context, state) => RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: (state.isLoading)
              ? _loadingIndicator
              : (state.isFailure)
                  ? SliverFillRemaining(child: ConnectionError())
                  : SafeArea(bottom: false, child: body),
        ),
      ),
    );
  }

  /// Centered [CircularProgressIndicator] widget.
  Widget get _loadingIndicator =>
      Center(child: const CircularProgressIndicator());
}

Future<void> _onRefresh<B extends NetworkBloc>(BuildContext context) {
  BlocProvider.of<B>(context).add(RefreshData());
}

/// It uses the [BlankPage] widget inside it.

/// Widget used to display a connection error message.
/// It allows user to reload the page with a simple button.
class ConnectionError<B extends NetworkBloc> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, NetworkState>(
      builder: (context, state) => BigTip(
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
        actionCallback: () async => _onRefresh(context),
        child: Icon(Icons.cloud_off),
      ),
    );
  }
}
