import 'dart:ui';

import 'package:custom_widget/2021_1_14/cupertino_task_view.dart';
import 'package:custom_widget/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _colors = Colors.primaries.map((e) => e.shade500).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildHorizontalScroll(),
      ),
    );
  }

  Widget _buildHorizontalScroll() {
    return CupertinoTaskView(
      builder: (context, index) {
        return View(
          showRight: true,
          color: _colors[index % _colors.length],
        );
      },
    );
  }
}
