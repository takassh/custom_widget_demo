import 'dart:ui';

import 'package:custom_widget/2022_1_13/cupertino_task_view.dart';
import 'package:custom_widget/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _leftIndex = 0;
  var _pixels = 0.0;
  final _base = 100;
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
                return View(
                  margin: EdgeInsets.zero,
                  width: 100,
                  color: _colors[index % _colors.length],
                );
              }

              if ((index - _leftIndex) % 4 == 0) {
                return Transform.scale(
                  scale: 0.97,
                  child: View(
                    margin: EdgeInsets.zero,
                    width: _factor(_base, _base, _pixels) < 0
                        ? 0
                        : _factor(_base, _base, _pixels),
                    showRight: index + 1 == kMaxItemCount,
                    color: _colors[index % _colors.length],
                  ),
                );
              } else if ((index - _leftIndex) % 4 == 1) {
                return Transform.scale(
                  scale: _factor(0.98, 0.97, _pixels),
                  child: View(
                    margin: EdgeInsets.zero,
                    width: _factor(150, _base, _pixels),
                    showRight: index + 1 == kMaxItemCount,
                    color: _colors[index % _colors.length],
                  ),
                );
              } else if ((index - _leftIndex) % 4 == 2) {
                return Transform.scale(
                  scale: _factor(0.99, 0.98, _pixels),
                  child: View(
                    margin: EdgeInsets.zero,
                    width: _factor(200, 150, _pixels),
                    showRight: index + 1 == kMaxItemCount,
                    color: _colors[index % _colors.length],
                  ),
                );
              } else if ((index - _leftIndex) % 4 == 3) {
                return Transform.scale(
                  scale: _factor(1.0, 0.99, _pixels),
                  child: View(
                    margin: EdgeInsets.zero,
                    width: _factor(300, 200, _pixels),
                    showRight: index + 1 == kMaxItemCount,
                    color: _colors[index % _colors.length],
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
