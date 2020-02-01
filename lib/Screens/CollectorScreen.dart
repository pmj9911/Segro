import 'dart:async';
import 'package:segro/Widgets/CollectorWidget.dart';
import 'package:flutter/material.dart';

class CollectorScreen extends StatefulWidget {
  @override
  _CollectorScreenState createState() => _CollectorScreenState();
}

class _CollectorScreenState extends State<CollectorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1
      body: Container(
        padding: EdgeInsets.all(10),
        child: CollectorWidget(),
      ),
    );
  }
}
