import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverFilip extends SingleChildRenderObjectWidget {
  const SliverFilip({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverFlip();
  }
}

class RenderSliverFlip extends RenderSliverSingleBoxAdapter {
  RenderSliverFlip();

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }

    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    final isOdd = constraints.scrollOffset.toInt().isOdd;
    print(constraints.scrollOffset);
    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      // layoutExtent: 40,
      scrollExtent: 500,
      paintExtent: 50,
      // paintOrigin: constraints.scrollOffset * 2,
      maxPaintExtent: 500,
      paintOrigin: 10,
      // hitTestExtent: paintedChildSize,
      // hasVisualOverflow: childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
  }
}
