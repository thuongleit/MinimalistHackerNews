import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hacker_news/blocs/blocs.dart';

import '../../presentation/widgets/reloadable_page.dart';

/// This widget is used for all tabs inside the app.
/// Its main features are connection error handling,
/// pull to refresh, as well as working as a sliver list.
class SliverPage<B extends NetworkBloc> extends StatelessWidget {
  final BuildContext context;
  final String title;
  final ScrollController controller;
  final List<Widget> body, actions;
  final Map<String, String> popupMenu;
  final bool enablePullToRefresh;

  const SliverPage({
    @required this.context,
    @required this.title,
    @required this.body,
    this.controller,
    this.actions,
    this.popupMenu,
    this.enablePullToRefresh,
  });

  factory SliverPage.slide({
    @required BuildContext context,
    @required String title,
    @required List<String> slides,
    @required List<Widget> body,
    List<Widget> actions,
    Map<String, String> popupMenu,
    bool enablePullToRefresh = true,
  }) {
    return SliverPage(
      context: context,
      title: title,
      body: body,
      actions: actions,
      popupMenu: popupMenu,
      enablePullToRefresh: enablePullToRefresh,
    );
  }

  factory SliverPage.display({
    @required BuildContext context,
    @required ScrollController controller,
    @required String title,
    @required double opacity,
    @required Widget counter,
    @required List<String> slides,
    @required List<Widget> body,
    List<Widget> actions,
    Map<String, String> popupMenu,
    bool enablePullToRefresh = true,
  }) {
    return SliverPage(
      context: context,
      controller: controller,
      title: title,
      body: body,
      actions: actions,
      popupMenu: popupMenu,
      enablePullToRefresh: enablePullToRefresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, NetworkState>(
      builder: (context, state) => enablePullToRefresh
          ? RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: _buildBody(context, state),
            )
          : _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, NetworkState state) {
    return CustomScrollView(
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
        if (state.isLoading)
          SliverFillRemaining(child: _loadingIndicator)
        else if (state.isFailure)
          SliverFillRemaining(child: ConnectionError())
        else
          ...body,
      ],
    );
  }

  /// Centered [CircularProgressIndicator] widget.
  Widget get _loadingIndicator =>
      Center(child: const CircularProgressIndicator());

  Future<void> _onRefresh<B extends NetworkBloc>(BuildContext context) {
    BlocProvider.of<B>(context).add(RefreshData());
  }
}
