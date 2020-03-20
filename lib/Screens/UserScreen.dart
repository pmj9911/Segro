import 'package:flutter/material.dart';

import '../Widgets/NearestBins.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1
      body: Container(
        padding: EdgeInsets.all(10),
        child: NearestBins(),
      ),
    );
  }
}