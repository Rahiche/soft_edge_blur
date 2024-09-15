import 'control_point_type.dart';

/// A control point used in defining the gradient mask for the blur effect.
class ControlPoint {
  /// Creates a [ControlPoint] with the given [position] and [type].
  ControlPoint({
    required this.position,
    required this.type,
  });

  /// Position between 0.0 and 1.0 along the edge.
  double position;

  /// Type of the control point (visible or transparent).
  ControlPointType type;
}
