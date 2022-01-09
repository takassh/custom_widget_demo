import 'package:flutter/material.dart';

class View extends StatelessWidget {
  final Color color;
  const View({Key? key, required this.color}) : super(key: key);

  static const height = 500.0;
  static const width = 300.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
