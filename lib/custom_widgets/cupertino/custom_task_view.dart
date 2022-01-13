import 'package:custom_widget/playground/custom_transform.dart';
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
    return Center(
      child: SizedBox(
        height: 500,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            // SizedBox(
            //   // width: 100,
            //   child: Transform.translate(
            //     offset: const Offset(0, 0),
            //     child: View(
            //       color: Colors.primaries[0 % Colors.primaries.length],
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: 100,
            //   child: Transform.translate(
            //     offset: const Offset(-250, 0),
            //     child: View(
            //       color: Colors.primaries[1 % Colors.primaries.length],
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: 100,
            //   child: Transform.translate(
            //     offset: const Offset(-300, 0),
            //     child: View(
            //       color: Colors.primaries[2 % Colors.primaries.length],
            //     ),
            //   ),
            // ),
            CustomTransform.translate(
              offset: const Offset(0, 0),
              child: View(
                color: Colors.primaries[0 % Colors.primaries.length],
              ),
            ),
            CustomTransform.translate(
              offset: const Offset(-250, 0),
              child: View(
                color: Colors.primaries[1 % Colors.primaries.length],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 0),
              child: View(
                color: Colors.primaries[2 % Colors.primaries.length],
              ),
            ),
            // _buildTransformed(0),
            // _buildTransformed(1),
            // _buildTransformed(2),
            // _buildTransformed(3),
          ],
        ),
      ),
    );
  }

  Widget _buildTransformed(int index) {
    return View(
      color: Colors.primaries[index % Colors.primaries.length],
    );
  }
}
