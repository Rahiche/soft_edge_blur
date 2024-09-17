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
  });

  /// The edge on which the blur will be applied.
  final EdgeType type;

  /// The size (in logical pixels) of the blur area along the edge.
  final double size;

  /// The sigma value for the Gaussian blur.
  final double sigma;

  /// A list of [ControlPoint] defining the gradient mask.
  final List<ControlPoint> controlPoints;
}
