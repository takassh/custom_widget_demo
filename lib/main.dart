import 'dart:ui';

import 'package:custom_widget/2021_1_13/cupertino_task_view.dart';
import 'package:custom_widget/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  var _leftIndex = 0;
  var _pixels = 0.0;
  final _base = 30;
  final _overlap = kOverlap;
  late final _tick = (_base - _overlap);
  final _colors = Colors.primaries.map((e) => e.shade500).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHorizontalScroll(),
    );
  }

  Widget _buildHorizontalScroll() {
    return Center(
      child: SizedBox(
        height: 500,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            setState(() {
              _pixels = notification.metrics.pixels;
              _leftIndex = (_pixels / _tick).floor();
            });
            return true;
          },
          child: CupertinoTaskView(
            leftIndex: _leftIndex,
            rightIndex: 0,
            builder: (context, index) {
              if (index < _leftIndex) {
                return SizedBox(width: _base.toDouble());
              } else if (index > _leftIndex + 3) {
                return SizedBox(
                  width: 300,
                  child: View(
                    color: _colors[index % _colors.length],
                  ),
                );
              }

              if ((index - _leftIndex) % 4 == 0) {
                return Transform.scale(
                  scale: 0.97,
                  child: SizedBox(
                    width: _factor(_base, _base, _pixels) < 0
                        ? 0
                        : _factor(_base, _base, _pixels),
                    child: View(
                      showRight: index + 1 == kMaxItemCount,
                      color: _colors[index % _colors.length],
                    ),
                  ),
                );
              } else if ((index - _leftIndex) % 4 == 1) {
                return Transform.scale(
                  scale: _factor(0.98, 0.97, _pixels),
                  child: SizedBox(
                    width: _factor(80, _base, _pixels),
                    child: View(
                      showRight: index + 1 == kMaxItemCount,
                      color: _colors[index % _colors.length],
                    ),
                  ),
                );
              } else if ((index - _leftIndex) % 4 == 2) {
                return Transform.scale(
                  scale: _factor(0.99, 0.98, _pixels),
                  child: SizedBox(
                    width: _factor(210, 80, _pixels),
                    child: View(
                      showRight: index + 1 == kMaxItemCount,
                      color: _colors[index % _colors.length],
                    ),
                  ),
                );
              } else if ((index - _leftIndex) % 4 == 3) {
                return Transform.scale(
                  scale: _factor(1.0, 0.99, _pixels),
                  child: SizedBox(
                    width: _factor(300, 210, _pixels),
                    child: View(
                      showRight: index + 1 == kMaxItemCount,
                      color: _colors[index % _colors.length],
                    ),
                  ),
                );
              }

              throw Error();
            },
          ),
        ),
      ),
    );
  }

  double _factor(num start, num end, double pixels) {
    final factor = lerpDouble(start, end, (pixels % _tick) / _tick);
    return start < end
        ? factor!.clamp(start, end).toDouble()
        : factor!.clamp(end, start).toDouble();
  }
}
