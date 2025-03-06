import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

import 'animated_sampler.dart';
import 'control_point_type.dart';
import 'edge_blur.dart';
import 'edge_type.dart';

/// A widget that applies a soft blur effect to the edges of its child.
class SoftEdgeBlur extends StatelessWidget {
  /// Creates a [SoftEdgeBlur] widget.
  ///
  /// The [edges] parameter defines which edges to apply the blur to and their settings.
  SoftEdgeBlur({
    super.key,
    required this.child,
    required this.edges,
  }) {
    assert(
      edges.map((e) => e.type).toSet().length == edges.length,
      'Duplicate edge types are not allowed',
    );
  }

  /// The child widget to which the blur effect will be applied.
  final Widget child;

  /// A list of [EdgeBlur] defining the edges to blur and their configurations.
  final List<EdgeBlur> edges;
  Stopwatch _stopwatch = Stopwatch();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: ShaderBuilder(
        (context, shader, child) {
          return AnimatedSampler(
            (ui.Image image, Size size, Canvas canvas) {
              _stopwatch.start();
              _drawCanvasShader(image, size, canvas, shader, context);
              // _drawCanvasPicture(image, size, canvas, context);
              // _drawCanvasWithClip(image, size, canvas, context);
              _stopwatch.stop();
              print("_stopwatch ${_stopwatch.elapsedMicroseconds}");
            },
            child: child!,
          );
        },
        child: child,
        assetKey: 'packages/soft_edge_blur/shader/flur.frag',
      ),
    );
  }

  void _drawCanvasShader(
    ui.Image image,
    Size size,
    Canvas canvas,
    ui.FragmentShader shader,
    BuildContext context,
  ) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    canvas.scale(1 / devicePixelRatio);

    // Draw the original image without blur
    canvas.drawImage(image, Offset.zero, Paint());

    for (final edge in edges) {
      final rect = _getEdgeRect(edge, size, devicePixelRatio);
      final isVertical =
          edge.type == EdgeType.topEdge || edge.type == EdgeType.bottomEdge;

      // Create gradient shader
      final gradient = _createGradient(edge, rect, isVertical);

      // Prepare the gradient paint with blend mode
      final gradientPaint = Paint()
        ..shader = gradient
        ..blendMode = BlendMode.dstIn;

      // Save the current canvas state
      canvas.saveLayer(rect, Paint());

      // Draw the blurred image within the rect
      final blurredPaint = Paint();
      shader.setFloat(0, size.width * devicePixelRatio);
      shader.setFloat(1, size.height * devicePixelRatio);
      shader.setImageSampler(0, image);
      blurredPaint.shader = shader;

      // canvas.drawImage(image, Offset.zero, blurredPaint);
      canvas.drawRect(rect, blurredPaint);

      // If tintColor is provided, draw the tint over the blurred content
      // if (edge.tintColor != null) {
      //   final tintPaint = Paint()
      //     ..color = edge.tintColor!
      //     ..blendMode = BlendMode.srcOver;
      //
      //   canvas.drawRect(rect, tintPaint);
      // }

      // Apply gradient mask to the blurred image
      // canvas.drawRect(rect, gradientPaint);

      // Restore canvas state
      canvas.restore();
    }
  }

  void _drawCanvas(
    ui.Image image,
    Size size,
    Canvas canvas,
    BuildContext context,
  ) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    canvas.scale(1 / devicePixelRatio);

    // Draw the original image without blur
    canvas.drawImage(image, Offset.zero, Paint());

    for (final edge in edges) {
      final rect = _getEdgeRect(edge, size, devicePixelRatio);
      final isVertical =
          edge.type == EdgeType.topEdge || edge.type == EdgeType.bottomEdge;

      // Create gradient shader
      final gradient = _createGradient(edge, rect, isVertical);

      // Prepare the gradient paint with blend mode
      final gradientPaint = Paint()
        ..shader = gradient
        ..blendMode = BlendMode.dstIn;

      // Save the current canvas state
      canvas.saveLayer(rect, Paint());

      // Draw the blurred image within the rect
      final blurredPaint = Paint()
        ..imageFilter = ui.ImageFilter.blur(
          sigmaX: edge.sigma,
          sigmaY: edge.sigma,
          tileMode: edge.tileMode,
        );

      canvas.drawImage(image, Offset.zero, blurredPaint);

      // If tintColor is provided, draw the tint over the blurred content
      if (edge.tintColor != null) {
        final tintPaint = Paint()
          ..color = edge.tintColor!
          ..blendMode = BlendMode.srcOver;

        canvas.drawRect(rect, tintPaint);
      }

      // Apply gradient mask to the blurred image
      canvas.drawRect(rect, gradientPaint);

      // Restore canvas state
      canvas.restore();
    }
  }

  void _drawCanvasPicture(
      ui.Image image, Size size, Canvas canvas, BuildContext context) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    canvas.scale(1 / devicePixelRatio);

    // Draw the original image without blur
    canvas.drawImage(image, Offset.zero, Paint());

    for (final edge in edges) {
      final rect = _getEdgeRect(edge, size, devicePixelRatio);
      final isVertical =
          edge.type == EdgeType.topEdge || edge.type == EdgeType.bottomEdge;

      // Create gradient shader
      final gradient = _createGradient(edge, rect, isVertical);

      // Create a separate canvas for the blurred and tinted content
      final pictureRecorder = ui.PictureRecorder();
      final blurCanvas = Canvas(pictureRecorder);
      final blurRect = Rect.fromLTWH(0, 0, rect.width, rect.height);

      // Draw the blurred image
      final blurredPaint = Paint()
        ..imageFilter = ui.ImageFilter.blur(
          sigmaX: edge.sigma,
          sigmaY: edge.sigma,
          tileMode: edge.tileMode,
        );
      blurCanvas.drawImageRect(
        image,
        rect,
        blurRect,
        blurredPaint,
      );

      // If tintColor is provided, draw the tint over the blurred content
      if (edge.tintColor != null) {
        final tintPaint = Paint()
          ..color = edge.tintColor!
          ..blendMode = BlendMode.srcOver;
        blurCanvas.drawRect(blurRect, tintPaint);
      }

      // Create an image from the blurred and tinted content
      final picture = pictureRecorder.endRecording();
      final blurredImage = picture.toImageSync(
        rect.width.toInt(),
        rect.height.toInt(),
      );

      // Draw the blurred and tinted image with the gradient mask
      final gradientPaint = Paint()
        ..shader = gradient
        ..blendMode = BlendMode.dstIn;

      canvas.saveLayer(rect, Paint());
      canvas.drawImage(blurredImage, rect.topLeft, Paint());
      canvas.drawRect(rect, gradientPaint);
      canvas.restore();
    }
  }

  void _drawCanvasWithClip(
    ui.Image image,
    Size size,
    Canvas canvas,
    BuildContext context,
  ) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    canvas.scale(1 / devicePixelRatio);

    // Draw the original image without blur
    canvas.drawImage(image, Offset.zero, Paint());

    for (final edge in edges) {
      final rect = _getEdgeRect(edge, size, devicePixelRatio);
      final isVertical =
          edge.type == EdgeType.topEdge || edge.type == EdgeType.bottomEdge;

      // Create gradient shader
      final gradient = _createGradient(edge, rect, isVertical);

      // Prepare the gradient paint with blend mode
      final gradientPaint = Paint()
        ..shader = gradient
        ..blendMode = BlendMode.dstIn;

      // Clip the canvas to the rect to limit the drawing area
      canvas.save();
      canvas.clipRect(rect);

      // Draw the blurred image within the rect
      final blurredPaint = Paint()
        ..imageFilter = ui.ImageFilter.blur(
          sigmaX: edge.sigma,
          sigmaY: edge.sigma,
          tileMode: edge.tileMode,
        );
      canvas.drawImage(image, Offset.zero, blurredPaint);

      // If tintColor is provided, draw the tint over the blurred content
      if (edge.tintColor != null) {
        final tintPaint = Paint()
          ..color = edge.tintColor!
          ..blendMode = BlendMode.srcOver;
        canvas.drawRect(rect, tintPaint);
      }

      // Apply gradient mask directly
      canvas.drawRect(rect, gradientPaint);

      // Restore the canvas to remove the clipRect
      canvas.restore();
    }
  }

  ui.Gradient _createGradient(EdgeBlur edge, Rect rect, bool isVertical) {
    // Extract positions and colors from control points
    final positions = edge.controlPoints.map((cp) => cp.position).toList();
    final colors = edge.controlPoints.map((cp) {
      return cp.type == ControlPointType.visible
          ? Colors.black
          : Colors.transparent;
    }).toList();

    // Pair positions with colors and sort them
    final sortedPairs = List.generate(positions.length, (index) => index)
      ..sort((a, b) => positions[a].compareTo(positions[b]));

    final sortedPositions = [for (var i in sortedPairs) positions[i]];
    final sortedColors = [for (var i in sortedPairs) colors[i]];

    // Create linear gradient based on orientation
    if ((edge.type == EdgeType.rightEdge) ||
        (edge.type == EdgeType.bottomEdge)) {
      // Reverse from/to when we are in the right/bottom edge
      return ui.Gradient.linear(
        isVertical ? rect.bottomCenter : rect.centerRight,
        isVertical ? rect.topCenter : rect.centerLeft,
        sortedColors,
        sortedPositions,
      );
    } else {
      return ui.Gradient.linear(
        isVertical ? rect.topCenter : rect.centerLeft,
        isVertical ? rect.bottomCenter : rect.centerRight,
        sortedColors,
        sortedPositions,
      );
    }
  }

  Rect _getEdgeRect(EdgeBlur edge, Size size, double devicePixelRatio) {
    final width = size.width * devicePixelRatio;
    final height = size.height * devicePixelRatio;
    switch (edge.type) {
      case EdgeType.topEdge:
        return Rect.fromLTRB(
          0,
          0,
          width,
          edge.size * devicePixelRatio,
        );
      case EdgeType.bottomEdge:
        return Rect.fromLTRB(
          0,
          height - edge.size * devicePixelRatio,
          width,
          height,
        );
      case EdgeType.leftEdge:
        return Rect.fromLTRB(
          0,
          0,
          edge.size * devicePixelRatio,
          height,
        );
      case EdgeType.rightEdge:
        return Rect.fromLTRB(
          width - edge.size * devicePixelRatio,
          0,
          width,
          height,
        );
    }
  }
}
