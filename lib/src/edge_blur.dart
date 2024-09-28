import 'dart:ui';

import 'control_point.dart';
import 'edge_type.dart';

/// Defines the blur effect to be applied on a specific edge.
class EdgeBlur {
  /// Creates an [EdgeBlur] effect for a specific edge with the given parameters.
  const EdgeBlur({
    required this.type,
    required this.size,
    required this.sigma,
    required this.controlPoints,
    this.tintColor,
    this.tileMode =
        TileMode.clamp, // Add the tileMode parameter with a default value
  });

  /// The edge on which the blur will be applied.
  final EdgeType type;

  /// The size (in logical pixels) of the blur area along the edge.
  final double size;

  /// The sigma value for the Gaussian blur.
  final double sigma;

  /// A list of [ControlPoint] defining the gradient mask.
  final List<ControlPoint> controlPoints;

  /// The tint color to be applied to the blur effect.
  final Color? tintColor;

  /// The tile mode to be used in the blur effect.
  final TileMode tileMode;
}
