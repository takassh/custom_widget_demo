import 'dart:ui';

import 'package:custom_widget/view.dart';
import 'package:flutter/material.dart';

class CupertinoTaskViewWidget extends StatefulWidget {
  const CupertinoTaskViewWidget({Key? key}) : super(key: key);

  @override
  _CupertinoTaskViewWidgetState createState() =>
      _CupertinoTaskViewWidgetState();
}

class _CupertinoTaskViewWidgetState extends State<CupertinoTaskViewWidget> {
  double _drag = 0;

  double get _scale {
    final scale = 1 + _drag / 2000;
    if (scale > 1) return 1;
    return scale;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            _drag += details.delta.dx;
          });
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Transform.translate(
              offset: Offset(_drag, 0),
              child: const View(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
