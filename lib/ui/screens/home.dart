import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hacker_news/repositories/stories.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../ui/tabs/index.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  ScrollController _scrollController;

  int _selectedIndex = 0;
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
          title: Text(getStoryTitle(type)),
        ),
      );
    }
    var tab = _tabs[_selectedIndex];
    // var statusBarSize = MediaQuery.of(context).padding.top;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewStoriesRepository()),
        ChangeNotifierProvider(create: (_) => TopStoriesRepository()),
        ChangeNotifierProvider(create: (_) => BestStoriesRepository()),
        ChangeNotifierProvider(create: (_) => AskStoriesRepository()),
        ChangeNotifierProvider(create: (_) => ShowStoriesRepository()),
        ChangeNotifierProvider(create: (_) => JobsStoriesRepository()),
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
            elevation: 4.0,
            selectedItemColor: Theme.of(context).accentColor,
            unselectedItemColor: Colors.grey[700],
            selectedFontSize: 10.0,
            unselectedFontSize: 10.0,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedLabelStyle: TextStyle(
              color: Colors.grey[700],
            ),
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
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
