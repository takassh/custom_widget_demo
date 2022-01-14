import 'package:flutter/material.dart';

class View extends StatelessWidget {
  final Color color;
  final bool showRight;
  final double width;
  final EdgeInsetsGeometry margin;
  const View(
      {Key? key,
      required this.color,
      this.showRight = false,
      this.width = 300,
      this.margin = const EdgeInsets.symmetric(horizontal: 4)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.12),
          //     blurRadius: 16,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
          color: color,
          borderRadius: !showRight
              ? const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                )
              : BorderRadius.circular(24),
        ),
      ),
    );
  }
}
