import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:soft_edge_blur/src/animated_sampler.dart';

enum EdgeType { topEdge, bottomEdge }

class EdgeBlur {
  final EdgeType type;
  final double size;
  final double sigma;

  const EdgeBlur(this.type, this.size, this.sigma);

  double get padding => sigma * 4;
  double get halfPadding => padding / 2;
}

class SoftEdgeBlur extends StatelessWidget {
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

  final Widget child;
  final List<EdgeBlur> edges;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSampler(
        (ui.Image image, Size size, Canvas canvas) {
          final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
          canvas.scale(1 / devicePixelRatio);

          // Draw the non-blurred portion
          canvas.drawImage(image, Offset.zero, Paint());

          for (final edge in edges) {
            final rect = _getEdgeRect(edge, size, devicePixelRatio);

            canvas.saveLayer(
              rect,
              Paint()
                ..imageFilter = ui.ImageFilter.blur(
                  sigmaX: edge.sigma,
                  sigmaY: edge.sigma,
                  tileMode: TileMode.decal,
                ),
            );

            canvas.drawImage(
              image,
              Offset.zero,
              Paint()
                ..imageFilter = ui.ImageFilter.blur(
                  sigmaX: edge.sigma,
                  sigmaY: edge.sigma,
                  tileMode: TileMode.clamp,
                ),
            );
          }
        },
        child: child,
      ),
    );
  }

  Rect _getEdgeRect(EdgeBlur edge, Size size, double devicePixelRatio) {
    switch (edge.type) {
      case EdgeType.topEdge:
        return Rect.fromLTWH(
          -edge.halfPadding,
          -edge.halfPadding,
          (size.width * devicePixelRatio) + edge.halfPadding,
          edge.size + edge.padding,
        );
      case EdgeType.bottomEdge:
        return Rect.fromLTWH(
          -edge.halfPadding,
          (size.height * devicePixelRatio) - edge.size,
          (size.width * devicePixelRatio) + edge.padding,
          edge.size + edge.padding,
        );
    }
  }
}
