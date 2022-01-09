import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ProgressBar extends LeafRenderObjectWidget {
  const ProgressBar({
    Key? key,
    required this.barColor,
    required this.thumbColor,
    this.thumbSize = 20.0,
  }) : super(key: key);

  final Color barColor;
  final Color thumbColor;
  final double thumbSize;

  @override
  RenderProgressBar createRenderObject(BuildContext context) {
    return RenderProgressBar(
      barColor: barColor,
      thumbColor: thumbColor,
      thumbSize: thumbSize,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderProgressBar renderObject) {
    renderObject
      ..barColor = barColor
      ..thumbColor = thumbColor
      ..thumbSize = thumbSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('barColor', barColor));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(DoubleProperty('thumbSize', thumbSize));
  }
}

class RenderProgressBar extends RenderBox {
  RenderProgressBar({
    required Color barColor,
    required Color thumbColor,
    required double thumbSize,
  })  : _barColor = barColor,
        _thumbColor = thumbColor,
        _thumbSize = thumbSize {
    // initialize the gesture recognizer
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = (DragStartDetails details) {
        _updateThumbPosition(details.localPosition);
      }
      ..onUpdate = (DragUpdateDetails details) {
        _updateThumbPosition(details.localPosition);
      };
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    // description
    config.textDirection = TextDirection.ltr;
    config.label = 'Progress bar';
    config.value = '${(_currentThumbValue * 100).round()}%';

    // increase action
    config.onIncrease = increaseAction;
    final increased = _currentThumbValue + _semanticActionUnit;
    config.increasedValue = '${((increased).clamp(0.0, 1.0) * 100).round()}%';

    // descrease action
    config.onDecrease = decreaseAction;
    final decreased = _currentThumbValue - _semanticActionUnit;
    config.decreasedValue = '${((decreased).clamp(0.0, 1.0) * 100).round()}%';
  }

  static const double _semanticActionUnit = 0.05;

  void increaseAction() {
    final newValue = _currentThumbValue + _semanticActionUnit;
    _currentThumbValue = (newValue).clamp(0.0, 1.0);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  void decreaseAction() {
    final newValue = _currentThumbValue - _semanticActionUnit;
    _currentThumbValue = (newValue).clamp(0.0, 1.0);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  bool get isRepaintBoundary => true;

  void _updateThumbPosition(Offset localPosition) {
    var dx = localPosition.dx.clamp(0, size.width);
    _currentThumbValue = dx / size.width;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  static const _minDesiredWidth = 100.0;
  @override
  double computeMinIntrinsicWidth(double height) => _minDesiredWidth;
  @override
  double computeMaxIntrinsicWidth(double height) => _minDesiredWidth;
  @override
  double computeMinIntrinsicHeight(double width) => thumbSize;
  @override
  double computeMaxIntrinsicHeight(double width) => thumbSize;

  double _currentThumbValue = 0.5;
  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    // paint bar
    final barPaint = Paint()
      ..color = barColor
      ..strokeWidth = 5;
    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width, size.height / 2);
    canvas.drawLine(point1, point2, barPaint);
    // paint thumb
    final thumbPaint = Paint()..color = thumbColor;
    final thumbDx = _currentThumbValue * size.width;
    final center = Offset(thumbDx, size.height / 2);
    canvas.drawCircle(center, thumbSize / 2, thumbPaint);
    canvas.restore();
  }

  late HorizontalDragGestureRecognizer _drag;
  @override
  bool hitTestSelf(Offset position) => true;
  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }

  Color get barColor => _barColor;
  Color _barColor;
  set barColor(Color value) {
    if (_barColor == value) return;
    _barColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  double get thumbSize => _thumbSize;
  double _thumbSize;
  set thumbSize(double value) {
    if (_thumbSize == value) return;
    _thumbSize = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final desiredWidth = constraints.maxWidth;
    final desiredHeight = thumbSize;
    final desiredSize = Size(desiredWidth, desiredHeight);
    return constraints.constrain(desiredSize);
  }
}
