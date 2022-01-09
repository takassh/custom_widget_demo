import 'package:flutter/material.dart';

import '../../view.dart';

class CupertinoTaskView extends StatefulWidget {
  const CupertinoTaskView({Key? key}) : super(key: key);

  @override
  _CupertinoTaskViewState createState() => _CupertinoTaskViewState();
}

class _CupertinoTaskViewState extends State<CupertinoTaskView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          widthFactor: 1.0,
          child: View(
            color: Colors.primaries[0 % Colors.primaries.length],
          ),
        ),
        Align(
          widthFactor: 0.01,
          child: View(
            color: Colors.primaries[1 % Colors.primaries.length],
          ),
        ),
        Align(
          widthFactor: 0.4,
          child: View(
            color: Colors.primaries[2 % Colors.primaries.length],
          ),
        ),
        Align(
          widthFactor: 0.4,
          child: View(
            color: Colors.primaries[3 % Colors.primaries.length],
          ),
        ),
        // _buildTransformed(0),
        // _buildTransformed(1),
        // _buildTransformed(2),
        // _buildTransformed(3),
      ],
    );
  }

  Widget _buildTransformed(int index) {
    return Align(
      widthFactor: 0.4,
      child: View(
        color: Colors.primaries[index % Colors.primaries.length],
      ),
    );
  }
}
