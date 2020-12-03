import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hacker_news/blocs/blocs.dart';

import '../../presentation/widgets/reloadable_page.dart';

/// This widget is used for all tabs inside the app.
/// Its main features are connection error handling,
/// pull to refresh, as well as working as a sliver list.
class SliverPage<C extends NetworkCubit> extends StatelessWidget {
  final BuildContext context;
  final String title;
  final Widget body;
  final ScrollController controller;
  final List<Widget> actions;
  final Map<String, dynamic> popupMenu;
  final bool enablePullToRefresh;
  final Widget customAppBar;
  final Widget viewIfEmptyData;
  final Function dataEmptyCondition;

  const SliverPage({
    @required this.context,
    @required this.body,
    this.title,
    this.customAppBar,
    this.controller,
    this.actions,
    this.popupMenu,
    this.enablePullToRefresh,
    this.viewIfEmptyData,
    this.dataEmptyCondition,
  });

  factory SliverPage.display({
    @required BuildContext context,
    @required Widget body,
    @required ScrollController controller,
    String title,
    List<Widget> actions,
    Map<String, dynamic> popupMenu,
    Widget customAppBar,
    bool enablePullToRefresh = true,
    Widget viewIfEmptyData,
    Function dataEmptyCondition,
  }) {
    return SliverPage(
      context: context,
      controller: controller,
      title: title,
      body: body,
      actions: actions,
      popupMenu: popupMenu,
      customAppBar: customAppBar,
      enablePullToRefresh: enablePullToRefresh,
      viewIfEmptyData: viewIfEmptyData,
      dataEmptyCondition: dataEmptyCondition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, NetworkState>(
      builder: (context, state) => enablePullToRefresh
          ? RefreshIndicator(
              onRefresh: () => context.read<C>().refresh(),
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
        customAppBar != null
            ? customAppBar
            : SliverAppBar(
                title: Text(title),
                actions: <Widget>[
                  if (actions != null) ...actions,
                  if (popupMenu != null)
                    PopupMenuButton<dynamic>(
                        itemBuilder: (context) => [
                              for (final item in popupMenu.keys)
                                PopupMenuItem(
                                  value: item,
                                  child: Text(
                                      FlutterI18n.translate(context, item)),
                                )
                            ],
                        onSelected: (action) {
                          if (popupMenu[action] is String) {
                            Navigator.pushNamed(context, popupMenu[action]);
                          } else if (popupMenu[action] is Function) {
                            popupMenu[action].call();
                          }
                        }),
                ],
              ),
        if (state.isInitial)
          Container()
        else if (state.isLoading)
          SliverFillRemaining(child: _loadingIndicator)
        else if (state.isFailure)
          SliverFillRemaining(
            child: ConnectionError(
              onRefresh: () => context.read<C>().refresh(),
            ),
          )
        else
          (dataEmptyCondition?.call() == true) || _isDataEmpty(state)
              ? SliverFillRemaining(
                  child: (viewIfEmptyData != null)
                      ? viewIfEmptyData
                      : Center(child: Text('No Data')),
                )
              : body,
      ],
    );
  }

  /// Centered [CircularProgressIndicator] widget.
  Widget get _loadingIndicator =>
      Center(child: const CircularProgressIndicator());

  bool _isDataEmpty(NetworkState state) {
    return state.data == null ||
        ((state.data is Iterable && (state.data as Iterable).isEmpty) ||
            ((state.data is Map && (state.data as Map).isEmpty)));
  }
}
