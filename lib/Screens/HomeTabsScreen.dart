import "package:flutter/material.dart";

import 'CollectorScreen.dart';
import 'SimulatorScreen.dart';
import 'UserScreen.dart';

class HomeTabs extends StatefulWidget {
  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
List<Map<String, Object>> _pages;
  bool refreshed = false;
  @override
  void initState() {
    _pages = [
      {
        'page': SimulatorScreen(),
        'title': 'Simulator',
      },
      {
        'page': CollectorScreen(),
        'title': 'Collector',
      },
      {
        'page': UserScreen(),
        'title': 'User',
      },
    ];
    super.initState();
  }

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //     child: Text(_pages[_selectedPageIndex]['title']),
      //   ),
      // ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.yellow,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.slideshow),
            title: Text("Simulator"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.control_point_duplicate),
            title: Text("Collector"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            title: Text("User"),
          ),
        ],
      ),
    );
  }
}
