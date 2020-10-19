import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../ui/tabs/index.dart';
import '../../database/index.dart';
import '../../repositories/stories.dart';
import '../../services/api.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  ScrollController _scrollController;

  int _currentIndex = 0;
  var _showToolbar;

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
      var type = _tabs[index];
      _navigationBarItems.add(
        BottomNavigationBarItem(
          icon: Icon(
            getStoryIcon(type),
            size: 24.0,
          ),
          title: Text(FlutterI18n.translate(context, getStoryTabKey(type))),
        ),
      );
    }
    var tab = _tabs[_currentIndex];
    // var statusBarSize = MediaQuery.of(context).padding.top;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewStoriesRepository(StoryDao.get(), ApiService.get())),
        ChangeNotifierProvider(create: (_) => TopStoriesRepository(StoryDao.get(), ApiService.get())),
        ChangeNotifierProvider(create: (_) => BestStoriesRepository(StoryDao.get(), ApiService.get())),
        ChangeNotifierProvider(create: (_) => AskStoriesRepository(StoryDao.get(), ApiService.get())),
        ChangeNotifierProvider(create: (_) => ShowStoriesRepository(StoryDao.get(), ApiService.get())),
        ChangeNotifierProvider(create: (_) => JobsStoriesRepository(StoryDao.get(), ApiService.get())),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(kToolbarHeight + statusBarSize),
        //   child: AnimatedContainer(
        //     height: _showToolbar ? kToolbarHeight + statusBarSize : 0.0,
        //     duration: Duration(milliseconds: 200),
        //     child: AppBar(
        //       title: Text(widget.title),
        //     ),
        //   ),
        // ),
        body: _buildBody(tab, _scrollController),
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
      ),
    );
  }

  Widget _buildBody(StoryType tab, ScrollController scrollController) {
    switch (tab) {
      case StoryType.news:
        return StoriesTab<NewStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      case StoryType.top:
        return StoriesTab<TopStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      case StoryType.best:
        return StoriesTab<BestStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      case StoryType.ask:
        return StoriesTab<AskStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      case StoryType.show:
        return StoriesTab<ShowStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      case StoryType.jobs:
        return StoriesTab<JobsStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      default:
        return Container();
    }
  }
}
