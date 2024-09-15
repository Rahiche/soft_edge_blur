 # SoftEdgeBlur

A Flutter package that provides a customizable soft edge blur effect for widgets.

<img width="547" alt="Map blurred" src="https://i.imgur.com/7DcixDz.png">

## Example 
| ![](https://i.imgur.com/ZHTocas.png) | ![](https://i.imgur.com/ejYRoGu.png) |
|--------------------------------------|--------------------------------------|
| ![](https://i.imgur.com/2B4RJo2.png) | ![](https://i.imgur.com/lrVGtHU.png) |


## Usage

Import the package in your Dart code:

```dart
import 'package:soft_edge_blur/soft_edge_blur.dart';
```

Wrap any widget with `SoftEdgeBlur` to apply the blur effect:

```dart
SoftEdgeBlur(
  edges: [
    EdgeBlur(
      EdgeType.topEdge,
      100.0, // Edge Size
      20.0, // Blur Sigma
      controlPoints: [
        ControlPoint(position: 0.5, type: ControlPointType.visible),
        ControlPoint(position: 1.0, type: ControlPointType.transparent),
      ],
    ),
  ],
  child: YourWidget(),
)
```

## Customization

You can customize the following properties for each edge:

### Edge Type

Specify which edges to apply the blur effect:

- `EdgeType.topEdge`
- `EdgeType.bottomEdge`
- `EdgeType.leftEdge`
- `EdgeType.rightEdge`

You can apply blur to multiple edges simultaneously.

### Edge Size

Set the size of the blurred area. This determines how far the blur effect extends from the edge of the widget.

### Blur Sigma

Adjust the intensity of the blur effect.

### Control Points

Define points to control the blur gradient along the edge. Each control point has two properties:

- `position`: A value between 0.0 and 1.0, representing the position along the edge.
- `type`: Either `ControlPointType.visible` or `ControlPointType.transparent`.


### Example Configuration

```dart
EdgeBlur(
  EdgeType.topEdge,
  100.0, // Edge Size
  20.0, // Blur Sigma
  controlPoints: [
    ControlPoint(position: 0.5, type: ControlPointType.visible),
    ControlPoint(position: 1.0, type: ControlPointType.transparent),
  ],
),
