import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hacker_news/repositories/stories.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../ui/tabs/index.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  ScrollController _scrollController;

  int _selectedIndex = 0;
  var _showToolbar;

  final List<StoryType> _tabs = <StoryType>[
    StoryType.NEW,
    StoryType.TOP,
    StoryType.ASK,
    StoryType.SHOW,
    StoryType.JOB
  ];

  final List<String> _tabTitles = <String>['new', 'top', 'ask', 'show', 'jobs'];

  final List<IconData> _tabIcons = <IconData>[
    Icons.new_releases,
    Icons.whatshot,
    Icons.question_answer,
    Icons.slideshow,
    Icons.work
  ];

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
    for (var i = 0; i < _tabs.length; i++) {
      _navigationBarItems.add(
        BottomNavigationBarItem(
          icon: Icon(
            _tabIcons[i],
            size: 24.0,
          ),
          title: Text(_tabTitles[i]),
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
        ChangeNotifierProvider(create: (_) => JobStoriesRepository()),
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
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody(StoryType tab, ScrollController scrollController) {
    switch (tab) {
      //enum StoryType { NEW, TOP, BEST, ASK, SHOW, JOB }
      case StoryType.NEW:
        return StoriesTab<NewStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      case StoryType.TOP:
        return StoriesTab<TopStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      case StoryType.BEST:
        return StoriesTab<BestStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      case StoryType.ASK:
        return StoriesTab<AskStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      case StoryType.SHOW:
        return StoriesTab<ShowStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      case StoryType.JOB:
        return StoriesTab<JobStoriesRepository>(
          key: ValueKey(tab.hashCode),
          storyType: tab,
          scrollController: scrollController,
        );
      default:
        return Container();
    }
  }
}
