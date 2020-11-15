import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacker_news/blocs/blocs.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../extensions/extensions.dart';
import '../tabs/tabs.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  ScrollController _scrollController;

  int _currentIndex = 0;
  bool _showToolbar;

  List<StoryType> get _tabs => StoryType.values;

  @override
  void initState() {
    _scrollController = ScrollController();
    _showToolbar = true;
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showToolbar) {
          setState(() {
            _showToolbar = false;
          });
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showToolbar) {
          setState(() {
            _showToolbar = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> _navigationBarItems =
        <BottomNavigationBarItem>[];
    for (var index = 0; index < _tabs.length; index++) {
      final StoryType type = _tabs[index];
      _navigationBarItems.add(
        BottomNavigationBarItem(
          icon: Icon(
            type.tabIcon,
            size: 24.0,
          ),
          label: FlutterI18n.translate(context, type.tabBarTitle),
        ),
      );
    }
    final type = _tabs[_currentIndex];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider<StoriesCubit>(
        create: (context) => StoriesCubit(StoriesRepositoryImpl()),
        child: StoriesTab(
          key: ValueKey(type.toString()),
          storyType: type,
          scrollController: _scrollController,
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: _showToolbar ? kBottomNavigationBarHeight : 0.0,
        child: BottomNavigationBar(
          items: _navigationBarItems,
          selectedLabelStyle: GoogleFonts.rubik(),
          unselectedLabelStyle: GoogleFonts.rubik(),
          elevation: 4.0,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Theme.of(context).unselectedWidgetColor,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (index) => _currentIndex != index
              ? setState(() => _currentIndex = index)
              : null,
        ),
      ),
    );
  }
}
