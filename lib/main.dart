import 'package:custom_widget/cupertino_task_view_2.dart';
import 'package:custom_widget/cupertino_task_view_widget.dart';
import 'package:custom_widget/sliver_flip.dart';
import 'package:custom_widget/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'cupertino_task_view.dart';
import 'custom_page_scroll_phsics.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(
    //     child: CupertinoTaskView(
    //       children: const [
    //         View(color: Colors.black),
    //         View(color: Colors.yellow)
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      body: _buildHorizontalScroll(),
    );
  }

  Widget _buildScrollable() {
    return CustomScrollView(
      physics: PageScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: Colors.blue,
            child: Text('hello'),
            height: 500,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.red,
            child: Text('hello'),
            height: 500,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.yellow,
            child: Text('hello'),
            height: 500,
          ),
        ),
        // SliverFilip(
        //   child: Container(
        //     color: Colors.red,
        //     child: Text('hello'),
        //     height: 500,
        //   ),
        // ),
        SliverList(delegate: SliverChildBuilderDelegate((context, index) {
          return SizedBox(
            height: 50,
            child: Text(
              index.toString(),
            ),
          );
        }))
      ],
    );
  }

  Widget _buildHorizontalScroll() {
    return Center(
      child: SizedBox(
        height: 500,
        child: CupertinoTaskView2(
          pageWidth: 300,
          builder: (context, index) {
            return View(
              color: Colors.primaries[index % Colors.primaries.length],
            );
          },
        ),
      ),
    );
  }
}
