import 'dart:async';

import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../repositories/base.dart';

/// Centered [CircularProgressIndicator] widget.
Widget get _loadingIndicator =>
    Center(child: const CircularProgressIndicator());

/// Function which handles reloading [QueryModel] models.
Future<void> _onRefresh(BuildContext context, BaseRepository repository) {
  final Completer<void> completer = Completer<void>();

  repository.refreshData().then((_) {
    if (repository.loadingFailed) {
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(FlutterI18n.translate(
              context,
              'app.messages.loading.connection_error.message',
            )),
            action: SnackBarAction(
              label: FlutterI18n.translate(
                context,
                'app.messages.loading.connection_error.reload',
              ),
              onPressed: () => _onRefresh(context, repository),
            ),
          ),
        );
    }
    completer.complete();
  });

  return completer.future;
}

/// Basic screen, which includes an [AppBar] widget.
/// Used when the desired page doesn't have slivers or reloading.
class SimplePage extends StatelessWidget {
  final String title;
  final Widget body, fab;
  final List<Widget> actions;

  const SimplePage({
    @required this.title,
    @required this.body,
    this.fab,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: actions,
      ),
      body: body,
      floatingActionButton: fab,
    );
  }
}

/// Basic page which has reloading properties.
/// It uses the [BlanckPage] widget inside it.
class ReloadablePage<T extends BaseRepository> extends StatelessWidget {
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
      body: Consumer<T>(
        builder: (context, model, child) => RefreshIndicator(
          onRefresh: () => _onRefresh(context, model),
          child: model.isLoading
              ? _loadingIndicator
              : model.loadingFailed
              ? SliverFillRemaining(
            child: ChangeNotifierProvider.value(
              value: model,
              child: ConnectionError<T>(),
            ),
          )
              : SafeArea(bottom: false, child: body),
        ),
      ),
    );
  }
}

/// This widget is used for all tabs inside the app.
/// Its main features are connection error handling,
/// pull to refresh, as well as working as a sliver list.
class SliverPage<T extends BaseRepository> extends StatelessWidget {
  final String title;
  final ScrollController controller;
  final List<Widget> body, actions;
  final Map<String, String> popupMenu;

  const SliverPage({
    @required this.title,
    @required this.body,
    this.controller,
    this.actions,
    this.popupMenu,
  });

  factory SliverPage.slide({
    @required String title,
    @required List<String> slides,
    @required List<Widget> body,
    List<Widget> actions,
    Map<String, String> popupMenu,
  }) {
    return SliverPage(
      title: title,
      body: body,
      actions: actions,
      popupMenu: popupMenu,
    );
  }

  factory SliverPage.display({
    @required ScrollController controller,
    @required String title,
    @required double opacity,
    @required Widget counter,
    @required List<String> slides,
    @required List<Widget> body,
    List<Widget> actions,
    Map<String, String> popupMenu,
  }) {
    return SliverPage(
      controller: controller,
      title: title,
      body: body,
      actions: actions,
      popupMenu: popupMenu,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => RefreshIndicator(
        onRefresh: () => _onRefresh(context, model),
        child: CustomScrollView(
          key: PageStorageKey(title),
          controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              title: Text(title),
              actions: <Widget>[
                if (actions != null) ...actions,
                if (popupMenu != null)
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      for (final item in popupMenu.keys)
                        PopupMenuItem(
                          value: item,
                          child: Text(FlutterI18n.translate(context, item)),
                        )
                    ],
                    onSelected: (text) =>
                        Navigator.pushNamed(context, popupMenu[text]),
                  ),
              ],
            ),
            if (model.isLoading)
              SliverFillRemaining(child: _loadingIndicator)
            else if (model.loadingFailed)
              SliverFillRemaining(
                child: ChangeNotifierProvider.value(
                  value: model,
                  child: ConnectionError<T>(),
                ),
              )
            else
              ...body,
          ],
        ),
      ),
    );
  }
}

/// Widget used to display a connection error message.
/// It allows user to reload the page with a simple button.
class ConnectionError<T extends BaseRepository> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => BigTip(
        subtitle: Text(
          FlutterI18n.translate(
            context,
            'app.messages.loading.connection_error.message',
          ),
          style:
          GoogleFonts.rubikTextTheme(Theme.of(context).textTheme).subtitle1,
        ),
        action: Text(
          FlutterI18n.translate(
            context,
            'app.messages.loading.connection_error.reload',
          ),
          style: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
              .subtitle1
              .copyWith(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actionCallback: () async => _onRefresh(context, model),
        child: Icon(Icons.cloud_off),
      ),
    );
  }
}
