import 'dart:io';

import 'package:flutter/material.dart';
import 'package:segro/Widgets/CameraWidget.dart';
import 'package:segro/Widgets/SimulateBins.dart';

class SimulatorScreen extends StatefulWidget {
  @override
  _SimulatorScreenState createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  List<Map<String, Object>> _pages;
  bool refreshed = false;
  @override
  void initState() {
    _pages = [
      {
        'page': CameraWidget(_selectImage),
        'title': 'Simulate Food Classifier',
      },
      {
        'page': SimulateBins(),
        'title': 'Simluate Bins',
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
      appBar: AppBar(
        title: Center(
          child: Text(_pages[_selectedPageIndex]['title']),
        ),
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.yellow,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            title: Text("Simulate Food Classifier"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_outline),
            title: Text("Simluate Bins"),
          ),
        ],
      ),
    );
  }
}
