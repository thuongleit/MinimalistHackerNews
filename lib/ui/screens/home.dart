import 'package:flutter/material.dart';
import '../../models/item.dart';
import '../../ui/widgets/item_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ItemList(
        key: ValueKey(tab.hashCode),
        type: tab,
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
