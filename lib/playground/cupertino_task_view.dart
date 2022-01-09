import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

/// Parent data for use with [RenderStack].
class CupertinoViewParentData extends ContainerBoxParentData<RenderBox> {
  /// The distance by which the child's top edge is inset from the top of the stack.
  double? top;

  /// The distance by which the child's right edge is inset from the right of the stack.
  double? right;

  /// The distance by which the child's bottom edge is inset from the bottom of the stack.
  double? bottom;

  /// The distance by which the child's left edge is inset from the left of the stack.
  double? left;

  /// The child's width.
  ///
  /// Ignored if both left and right are non-null.
  double? width;

  /// The child's height.
  ///
  /// Ignored if both top and bottom are non-null.
  double? height;

  /// Get or set the current values in terms of a RelativeRect object.
  RelativeRect get rect => RelativeRect.fromLTRB(left!, top!, right!, bottom!);
  set rect(RelativeRect value) {
    top = value.top;
    right = value.right;
    bottom = value.bottom;
    left = value.left;
  }

  /// Whether this child is considered positioned.
  ///
  /// A child is positioned if any of the top, right, bottom, or left properties
  /// are non-null. Positioned children do not factor into determining the size
  /// of the stack but are instead placed relative to the non-positioned
  /// children in the stack.
  bool get isPositioned =>
      top != null ||
      right != null ||
      bottom != null ||
      left != null ||
      width != null ||
      height != null;
}

class CupertinoView extends StatefulWidget {
  final List<Widget> children;
  const CupertinoView({Key? key, required this.children}) : super(key: key);

  @override
  _CupertinoViewState createState() => _CupertinoViewState();
}

class _CupertinoViewState extends State<CupertinoView> {
  @override
  Widget build(BuildContext context) {
    return Scrollable(
      physics: const PageScrollPhysics(),
      scrollBehavior:
          ScrollConfiguration.of(context).copyWith(scrollbars: false),
      viewportBuilder: (BuildContext context, ViewportOffset position) {
        return Viewport(
          cacheExtent: 0.0,
          cacheExtentStyle: CacheExtentStyle.viewport,
          axisDirection: AxisDirection.right,
          offset: position,
          slivers: [
            SliverFillViewport(
              delegate: SliverChildListDelegate(widget.children),
            ),
          ],
        );
      },
    );
  }
}

class CupertinoTaskView extends MultiChildRenderObjectWidget {
  CupertinoTaskView({
    Key? key,
    List<Widget> children = const <Widget>[],
  }) : super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCupertinoTaskView();
  }
}

class RenderCupertinoTaskView extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CupertinoViewParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CupertinoViewParentData> {
  /// Creates a stack render object.
  ///
  /// By default, the non-positioned children of the stack are aligned by their
  /// top left corners.
  RenderCupertinoTaskView({
    List<RenderBox>? children,
  }) {
    // initialize the gesture recognizer
    _drag = HorizontalDragGestureRecognizer()
      ..onUpdate = (DragUpdateDetails details) {
        _updateSlidePosition(details.delta);
      };
    addAll(children);
  }

  double _currentSlideValue = 0;

  double _childSlideValue(int i) {
    return (_currentSlideValue + (i * 150)).clamp(-40, double.infinity);
  }

  void _updateSlidePosition(Offset delta) {
    _currentSlideValue += delta.dx;

    markNeedsPaint();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! CupertinoViewParentData) {
      child.parentData = CupertinoViewParentData();
    }
  }

  /// Helper function for calculating the intrinsics metrics of a Stack.
  static double getIntrinsicDimension(RenderBox? firstChild,
      double Function(RenderBox child) mainChildSizeGetter) {
    double extent = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      final CupertinoViewParentData childParentData =
          child.parentData! as CupertinoViewParentData;
      if (!childParentData.isPositioned) {
        extent = math.max(extent, mainChildSizeGetter(child));
      }
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    return extent;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return getIntrinsicDimension(
        firstChild, (RenderBox child) => child.getMinIntrinsicWidth(height));
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return getIntrinsicDimension(
        firstChild, (RenderBox child) => child.getMaxIntrinsicWidth(height));
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return getIntrinsicDimension(
        firstChild, (RenderBox child) => child.getMinIntrinsicHeight(width));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return getIntrinsicDimension(
        firstChild, (RenderBox child) => child.getMaxIntrinsicHeight(width));
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );
  }

  Size _computeSize(
      {required BoxConstraints constraints,
      required ChildLayouter layoutChild}) {
    bool hasNonPositionedChildren = false;
    if (childCount == 0) {
      assert(constraints.biggest.isFinite);
      return constraints.biggest;
    }

    double width = constraints.minWidth;
    double height = constraints.minHeight;

    final BoxConstraints nonPositionedConstraints = constraints.loosen();

    RenderBox? child = firstChild;
    while (child != null) {
      final CupertinoViewParentData childParentData =
          child.parentData! as CupertinoViewParentData;

      if (!childParentData.isPositioned) {
        hasNonPositionedChildren = true;

        final Size childSize = layoutChild(child, nonPositionedConstraints);

        width = math.max(width, childSize.width);
        height = math.max(height, childSize.height);
      }

      child = childParentData.nextSibling;
    }

    final Size size;
    if (hasNonPositionedChildren) {
      size = Size(width, height);
      assert(size.width == constraints.constrainWidth(width));
      assert(size.height == constraints.constrainHeight(height));
    } else {
      size = constraints.biggest;
    }

    assert(size.isFinite);
    return size;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    // _hasVisualOverflow = false;

    size = _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );

    // assert(_resolvedAlignment != null);
    RenderBox? child = firstChild;
    while (child != null) {
      final CupertinoViewParentData childParentData =
          child.parentData! as CupertinoViewParentData;

      // if (!childParentData.isPositioned) {
      //   childParentData.offset = _resolvedAlignment!.alongOffset(size - child.size as Offset);
      // } else {
      //   _hasVisualOverflow = layoutPositionedChild(child, childParentData, size, _resolvedAlignment!) || _hasVisualOverflow;
      // }

      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  late HorizontalDragGestureRecognizer _drag;
  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    var i = 0;
    while (child != null) {
      final CupertinoViewParentData childParentData =
          child.parentData! as CupertinoViewParentData;
      void painter(PaintingContext context, Offset offset) {
        context.paintChild(child!, offset);
      }

      context.pushTransform(
        needsCompositing,
        offset,
        Matrix4.identity()..translate(_childSlideValue(i)),
        painter,
        oldLayer: _transformLayer.layer,
      );

      i++;
      child = childParentData.nextSibling;
    }
  }

  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  final LayerHandle<TransformLayer> _transformLayer =
      LayerHandle<TransformLayer>();

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    _transformLayer.layer = null;
    super.dispose();
  }
}
