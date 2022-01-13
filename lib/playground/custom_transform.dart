// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui show Image, ImageFilter, TextHeightBehavior;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// POSITIONING AND SIZING NODES

/// A widget that applies a transformation before painting its child.
///
/// Unlike [RotatedBox], which applies a rotation prior to layout, this object
/// applies its transformation just prior to painting, which means the
/// transformation is not taken into account when calculating how much space
/// this widget's child (and thus this widget) consumes.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=9z_YNlRlWfA}
///
/// {@tool snippet}
///
/// This example rotates and skews an orange box containing text, keeping the
/// top right corner pinned to its original position.
///
/// ```dart
/// Container(
///   color: Colors.black,
///   child: Transform(
///     alignment: Alignment.topRight,
///     transform: Matrix4.skewY(0.3)..rotateZ(-math.pi / 12.0),
///     child: Container(
///       padding: const EdgeInsets.all(8.0),
///       color: const Color(0xFFE8581C),
///       child: const Text('Apartment for rent!'),
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [RotatedBox], which rotates the child widget during layout, not just
///    during painting.
///  * [FractionalTranslation], which applies a translation to the child
///    that is relative to the child's size.
///  * [FittedBox], which sizes and positions its child widget to fit the parent
///    according to a given [BoxFit] discipline.
///  * The [catalog of layout widgets](https://flutter.dev/widgets/layout/).
class CustomTransform extends SingleChildRenderObjectWidget {
  /// Creates a widget that transforms its child.
  ///
  /// The [transform] argument must not be null.
  const CustomTransform({
    Key? key,
    required this.transform,
    this.origin,
    this.alignment,
    this.transformHitTests = true,
    this.filterQuality,
    Widget? child,
  })  : assert(transform != null),
        super(key: key, child: child);

  /// Creates a widget that transforms its child using a rotation around the
  /// center.
  ///
  /// The `angle` argument must not be null. It gives the rotation in clockwise
  /// radians.
  ///
  /// {@tool snippet}
  ///
  /// This example rotates an orange box containing text around its center by
  /// fifteen degrees.
  ///
  /// ```dart
  /// Transform.rotate(
  ///   angle: -math.pi / 12.0,
  ///   child: Container(
  ///     padding: const EdgeInsets.all(8.0),
  ///     color: const Color(0xFFE8581C),
  ///     child: const Text('Apartment for rent!'),
  ///   ),
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [RotationTransition], which animates changes in rotation smoothly
  ///    over a given duration.
  CustomTransform.rotate({
    Key? key,
    required double angle,
    this.origin,
    this.alignment = Alignment.center,
    this.transformHitTests = true,
    this.filterQuality,
    Widget? child,
  })  : transform = Matrix4.rotationZ(angle),
        super(key: key, child: child);

  /// Creates a widget that transforms its child using a translation.
  ///
  /// The `offset` argument must not be null. It specifies the translation.
  ///
  /// {@tool snippet}
  ///
  /// This example shifts the silver-colored child down by fifteen pixels.
  ///
  /// ```dart
  /// Transform.translate(
  ///   offset: const Offset(0.0, 15.0),
  ///   child: Container(
  ///     padding: const EdgeInsets.all(8.0),
  ///     color: const Color(0xFF7F7F7F),
  ///     child: const Text('Quarter'),
  ///   ),
  /// )
  /// ```
  /// {@end-tool}
  CustomTransform.translate({
    Key? key,
    required Offset offset,
    this.transformHitTests = true,
    this.filterQuality,
    Widget? child,
  })  : transform = Matrix4.translationValues(offset.dx, offset.dy, 0.0),
        origin = null,
        alignment = null,
        super(key: key, child: child);

  /// Creates a widget that scales its child uniformly.
  ///
  /// The `scale` argument must not be null. It gives the scalar by which
  /// to multiply the `x` and `y` axes.
  ///
  /// The [alignment] controls the origin of the scale; by default, this is
  /// the center of the box.
  ///
  /// {@tool snippet}
  ///
  /// This example shrinks an orange box containing text such that each dimension
  /// is half the size it would otherwise be.
  ///
  /// ```dart
  /// Transform.scale(
  ///   scale: 0.5,
  ///   child: Container(
  ///     padding: const EdgeInsets.all(8.0),
  ///     color: const Color(0xFFE8581C),
  ///     child: const Text('Bad Idea Bears'),
  ///   ),
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [ScaleTransition], which animates changes in scale smoothly
  ///    over a given duration.
  CustomTransform.scale({
    Key? key,
    required double scale,
    this.origin,
    this.alignment = Alignment.center,
    this.transformHitTests = true,
    this.filterQuality,
    Widget? child,
  })  : transform = Matrix4.diagonal3Values(scale, scale, 1.0),
        super(key: key, child: child);

  /// The matrix to transform the child by during painting.
  final Matrix4 transform;

  /// The origin of the coordinate system (relative to the upper left corner of
  /// this render object) in which to apply the matrix.
  ///
  /// Setting an origin is equivalent to conjugating the transform matrix by a
  /// translation. This property is provided just for convenience.
  final Offset? origin;

  /// The alignment of the origin, relative to the size of the box.
  ///
  /// This is equivalent to setting an origin based on the size of the box.
  /// If it is specified at the same time as the [origin], both are applied.
  ///
  /// An [AlignmentDirectional.centerStart] value is the same as an [Alignment]
  /// whose [Alignment.x] value is `-1.0` if [Directionality.of] returns
  /// [TextDirection.ltr], and `1.0` if [Directionality.of] returns
  /// [TextDirection.rtl].	 Similarly [AlignmentDirectional.centerEnd] is the
  /// same as an [Alignment] whose [Alignment.x] value is `1.0` if
  /// [Directionality.of] returns	 [TextDirection.ltr], and `-1.0` if
  /// [Directionality.of] returns [TextDirection.rtl].
  final AlignmentGeometry? alignment;

  /// Whether to apply the transformation when performing hit tests.
  final bool transformHitTests;

  /// The filter quality with which to apply the transform as a bitmap operation.
  ///
  /// {@template flutter.widgets.Transform.optional.FilterQuality}
  /// The transform will be applied by re-rendering the child if [filterQuality] is null,
  /// otherwise it controls the quality of an [ImageFilter.matrix] applied to a bitmap
  /// rendering of the child.
  /// {@endtemplate}
  final FilterQuality? filterQuality;

  @override
  CustomRenderTransform createRenderObject(BuildContext context) {
    return CustomRenderTransform(
      transform: transform,
      origin: origin,
      alignment: alignment,
      textDirection: Directionality.maybeOf(context),
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, CustomRenderTransform renderObject) {
    renderObject
      ..transform = transform
      ..origin = origin
      ..alignment = alignment
      ..textDirection = Directionality.maybeOf(context)
      ..transformHitTests = transformHitTests
      ..filterQuality = filterQuality;
  }
}

/// Applies a transformation before painting its child.
class CustomRenderTransform extends RenderProxyBox {
  /// Creates a render object that transforms its child.
  ///
  /// The [transform] argument must not be null.
  CustomRenderTransform({
    required Matrix4 transform,
    Offset? origin,
    AlignmentGeometry? alignment,
    TextDirection? textDirection,
    this.transformHitTests = true,
    FilterQuality? filterQuality,
    RenderBox? child,
  })  : assert(transform != null),
        super(child) {
    this.transform = transform;
    this.alignment = alignment;
    this.textDirection = textDirection;
    this.filterQuality = filterQuality;
    this.origin = origin;
  }

  /// The origin of the coordinate system (relative to the upper left corner of
  /// this render object) in which to apply the matrix.
  ///
  /// Setting an origin is equivalent to conjugating the transform matrix by a
  /// translation. This property is provided just for convenience.
  Offset? get origin => _origin;
  Offset? _origin;
  set origin(Offset? value) {
    if (_origin == value) return;
    _origin = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// The alignment of the origin, relative to the size of the box.
  ///
  /// This is equivalent to setting an origin based on the size of the box.
  /// If it is specified at the same time as an offset, both are applied.
  ///
  /// An [AlignmentDirectional.centerStart] value is the same as an [Alignment]
  /// whose [Alignment.x] value is `-1.0` if [textDirection] is
  /// [TextDirection.ltr], and `1.0` if [textDirection] is [TextDirection.rtl].
  /// Similarly [AlignmentDirectional.centerEnd] is the same as an [Alignment]
  /// whose [Alignment.x] value is `1.0` if [textDirection] is
  /// [TextDirection.ltr], and `-1.0` if [textDirection] is [TextDirection.rtl].
  AlignmentGeometry? get alignment => _alignment;
  AlignmentGeometry? _alignment;
  set alignment(AlignmentGeometry? value) {
    if (_alignment == value) return;
    _alignment = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// The text direction with which to resolve [alignment].
  ///
  /// This may be changed to null, but only after [alignment] has been changed
  /// to a value that does not depend on the direction.
  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  bool get alwaysNeedsCompositing => child != null && _filterQuality != null;

  /// When set to true, hit tests are performed based on the position of the
  /// child as it is painted. When set to false, hit tests are performed
  /// ignoring the transformation.
  ///
  /// [applyPaintTransform], and therefore [localToGlobal] and [globalToLocal],
  /// always honor the transformation, regardless of the value of this property.
  bool transformHitTests;

  // Note the lack of a getter for transform because Matrix4 is not immutable
  Matrix4? _transform;

  /// The matrix to transform the child by during painting.
  set transform(Matrix4 value) {
    assert(value != null);
    if (_transform == value) return;
    _transform = Matrix4.copy(value);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// The filter quality with which to apply the transform as a bitmap operation.
  ///
  /// {@macro flutter.widgets.Transform.optional.FilterQuality}
  FilterQuality? get filterQuality => _filterQuality;
  FilterQuality? _filterQuality;
  set filterQuality(FilterQuality? value) {
    if (_filterQuality == value) return;
    final bool didNeedCompositing = alwaysNeedsCompositing;
    _filterQuality = value;
    if (didNeedCompositing != alwaysNeedsCompositing)
      markNeedsCompositingBitsUpdate();
    markNeedsPaint();
  }

  /// Sets the transform to the identity matrix.
  void setIdentity() {
    _transform!.setIdentity();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Concatenates a rotation about the x axis into the transform.
  void rotateX(double radians) {
    _transform!.rotateX(radians);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Concatenates a rotation about the y axis into the transform.
  void rotateY(double radians) {
    _transform!.rotateY(radians);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Concatenates a rotation about the z axis into the transform.
  void rotateZ(double radians) {
    _transform!.rotateZ(radians);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Concatenates a translation by (x, y, z) into the transform.
  void translate(double x, [double y = 0.0, double z = 0.0]) {
    _transform!.translate(x, y, z);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Concatenates a scale into the transform.
  void scale(double x, [double? y, double? z]) {
    _transform!.scale(x, y, z);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  Matrix4? get _effectiveTransform {
    final Alignment? resolvedAlignment = alignment?.resolve(textDirection);
    if (_origin == null && resolvedAlignment == null) return _transform;
    final Matrix4 result = Matrix4.identity();
    if (_origin != null) result.translate(_origin!.dx, _origin!.dy);
    Offset? translation;
    if (resolvedAlignment != null) {
      translation = resolvedAlignment.alongSize(size);
      result.translate(translation.dx, translation.dy);
    }
    result.multiply(_transform!);
    if (resolvedAlignment != null)
      result.translate(-translation!.dx, -translation.dy);
    if (_origin != null) result.translate(-_origin!.dx, -_origin!.dy);
    return result;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // CustomRenderTransform objects don't check if they are
    // themselves hit, because it's confusing to think about
    // how the untransformed size and the child's transformed
    // position interact.
    return hitTestChildren(result, position: position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    assert(!transformHitTests || _effectiveTransform != null);
    return result.addWithPaintTransform(
      transform: transformHitTests ? _effectiveTransform : null,
      position: position,
      hitTest: (BoxHitTestResult result, Offset? position) {
        return super.hitTestChildren(result, position: position!);
      },
    );
  }

  @override
  void performLayout() {
    child!.layout(constraints, parentUsesSize: true);
    final childSize = child!.size;
    // size = childSize;
    final width = 300;
    final data = child!.parentData!;
    size = Size(childSize.width + (_effectiveTransform?.entry(0, 3) ?? 0),
        childSize.height);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    // final transform = _effectiveTransform;

    final childSize = child!.getDryLayout(constraints);
    return childSize;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final Matrix4 transform = _effectiveTransform!;
      if (filterQuality == null) {
        final Offset? childOffset = MatrixUtils.getAsTranslation(transform);
        if (childOffset == null) {
          layer = context.pushTransform(
            needsCompositing,
            offset,
            transform,
            super.paint,
            oldLayer: layer is TransformLayer ? layer as TransformLayer? : null,
          );
        } else {
          super.paint(context, offset + childOffset);
          layer = null;
        }
      } else {
        final ui.ImageFilter filter = ui.ImageFilter.matrix(
          transform.storage,
          filterQuality: filterQuality!,
        );
        if (layer is ImageFilterLayer) {
          final ImageFilterLayer filterLayer = layer! as ImageFilterLayer;
          filterLayer.imageFilter = filter;
        } else {
          layer = ImageFilterLayer(imageFilter: filter);
        }
        context.pushLayer(layer!, super.paint, offset);
      }
    }
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(_effectiveTransform!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(TransformProperty('transform matrix', _transform));
    properties.add(DiagnosticsProperty<Offset>('origin', origin));
    properties
        .add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty<bool>('transformHitTests', transformHitTests));
  }
}
