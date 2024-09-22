
 
 # SoftEdgeBlur
[![pub package](https://img.shields.io/pub/v/soft_edge_blur.svg)](https://pub.dev/packages/soft_edge_blur)


A Flutter package that provides a customizable soft progressive blur effect for widgets.

<img width="547" alt="Map blurred" src="https://i.imgur.com/7DcixDz.png">


## Demos
## Map - with control points
| ![](https://i.imgur.com/ZHTocas.png) | ![](https://i.imgur.com/ejYRoGu.png) |
|--------------------------------------|--------------------------------------|
| ![](https://i.imgur.com/2B4RJo2.png) | ![](https://i.imgur.com/lrVGtHU.png) |

## Airbnb Card with tint color

<img width="522" alt="Screenshot 2024-09-17 at 22 22 01" src="https://github.com/user-attachments/assets/91155a1d-7552-4e22-922c-402192d46149">

## Music play list with tint color

<img width="522" alt="Screenshot 2024-09-17 at 22 22 01" src="https://i.imgur.com/QjmfnIL.jpeg">

## Usage

Import the package in your Dart code:

```dart
import 'package:soft_edge_blur/soft_edge_blur.dart';
```

Wrap any widget with `SoftEdgeBlur` to apply the blur effect:

```dart
return SoftEdgeBlur(
  edges: [
    EdgeBlur(
      type: EdgeType.topEdge,
      size: 100,
      sigma: 30,
      controlPoints: [
        ControlPoint(
          position: 0.5,
          type: ControlPointType.visible,
        ),
        ControlPoint(
          position: 1,
          type: ControlPointType.transparent,
        )
      ],
    )
  ],
  child: YourWidget(),
);
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

### Tint Color
Apply a tint color on top of the blurred area.

### Control Points
Define points to control the blur gradient along the edge. Each control point has two properties:

- `position`: A value between 0.0 and 1.0, representing the position along the edge.
- `type`: Either `ControlPointType.visible` or `ControlPointType.transparent`.

### Try it live here

https://soft_edge_blur.codemagic.app/
