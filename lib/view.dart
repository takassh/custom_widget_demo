import 'package:flutter/material.dart';

class View extends StatelessWidget {
  final Color color;
  final bool showRight;
  const View({Key? key, required this.color, this.showRight = false})
      : super(key: key);

  static const height = 500.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: !showRight
            ? const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              )
            : BorderRadius.circular(16),
      ),
    );
  }
}
