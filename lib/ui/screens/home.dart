import 'package:flutter/material.dart';
import 'package:hacker_news/models/item.dart';
import 'package:hacker_news/ui/widgets/item_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final double _iconSize = 24.0;

  final List<String> _tabTitles = <String>['New', 'Hot', 'Ask', 'Show', 'Jobs'];
  final List<IconData> _tabIcons = <IconData>[
    Icons.new_releases,
    Icons.whatshot,
    Icons.question_answer,
    Icons.slideshow,
    Icons.work,
  ];

  final List<Widget> _screens = <Widget>[
    ItemList(type: StoryType.NEW),
    ItemList(type: StoryType.TOP),
    ItemList(type: StoryType.ASK),
    ItemList(type: StoryType.SHOW),
    ItemList(type: StoryType.JOB),
  ];

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> _navigationBarItems =
        <BottomNavigationBarItem>[];
    for (var i = 0; i < _screens.length; i++) {
      _navigationBarItems.add(
        BottomNavigationBarItem(
          icon: Icon(
            _tabIcons[i],
            size: _iconSize,
          ),
          title: Text(_tabTitles[i]),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navigationBarItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}