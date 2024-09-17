import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

void main() {
  group('SoftEdgeBlur golden tests', () {
    // Function to build a grid of colors
    Widget buildColorGrid() {
      final colors = [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.yellow,
        Colors.orange,
        Colors.purple,
        Colors.teal,
        Colors.cyan,
      ];

      return SizedBox(
        width: 200,
        height: 200,
        child: Column(
          children: List.generate(4, (rowIndex) {
            return Expanded(
              child: Row(
                children: List.generate(4, (colIndex) {
                  final colorIndex = (rowIndex * 4 + colIndex) % colors.length;
                  return Expanded(
                    child: Container(color: colors[colorIndex]),
                  );
                }),
              ),
            );
          }),
        ),
      );
    }

    testWidgets('SoftEdgeBlur with top edge blur', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SoftEdgeBlur(
              edges: [
                EdgeBlur(
                  type: EdgeType.topEdge,
                  size: 30.0,
                  sigma: 20.0,
                  controlPoints: [
                    ControlPoint(
                      position: 0.5,
                      type: ControlPointType.visible,
                    ),
                    ControlPoint(
                      position: 1.0,
                      type: ControlPointType.transparent,
                    ),
                  ],
                ),
              ],
              child: buildColorGrid(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SoftEdgeBlur),
        matchesGoldenFile('goldens/soft_edge_blur_top_edge.png'),
      );
    });

    testWidgets('SoftEdgeBlur with bottom edge blur',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(devicePixelRatio: 1.0),
              child: SoftEdgeBlur(
                edges: [
                  EdgeBlur(
                    type: EdgeType.bottomEdge,
                    size: 50.0,
                    sigma: 10.0,
                    controlPoints: [
                      ControlPoint(
                        position: 1.0,
                        type: ControlPointType.visible,
                      ),
                      ControlPoint(
                        position: 0.5,
                        type: ControlPointType.transparent,
                      ),
                    ],
                  ),
                ],
                child: buildColorGrid(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SoftEdgeBlur),
        matchesGoldenFile('goldens/soft_edge_blur_bottom_edge.png'),
      );
    });

    testWidgets('SoftEdgeBlur with left edge blur',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(devicePixelRatio: 1.0),
              child: SoftEdgeBlur(
                edges: [
                  EdgeBlur(
                    type: EdgeType.leftEdge,
                    size: 50.0,
                    sigma: 10.0,
                    controlPoints: [
                      ControlPoint(
                        position: 0.5,
                        type: ControlPointType.visible,
                      ),
                      ControlPoint(
                        position: 1.0,
                        type: ControlPointType.transparent,
                      ),
                    ],
                  ),
                ],
                child: buildColorGrid(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SoftEdgeBlur),
        matchesGoldenFile('goldens/soft_edge_blur_left_edge.png'),
      );
    });

    testWidgets('SoftEdgeBlur with right edge blur',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(devicePixelRatio: 1.0),
              child: SoftEdgeBlur(
                edges: [
                  EdgeBlur(
                    type: EdgeType.rightEdge,
                    size: 50.0,
                    sigma: 10.0,
                    controlPoints: [
                      ControlPoint(
                        position: 0.5,
                        type: ControlPointType.transparent,
                      ),
                      ControlPoint(
                        position: 1.0,
                        type: ControlPointType.visible,
                      ),
                    ],
                  ),
                ],
                child: buildColorGrid(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SoftEdgeBlur),
        matchesGoldenFile('goldens/soft_edge_blur_right_edge.png'),
      );
    });

    testWidgets('SoftEdgeBlur with multiple edges blur',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(devicePixelRatio: 1.0),
              child: SoftEdgeBlur(
                edges: [
                  EdgeBlur(
                    type: EdgeType.topEdge,
                    size: 30.0,
                    sigma: 20.0,
                    controlPoints: [
                      ControlPoint(
                        position: 0.5,
                        type: ControlPointType.visible,
                      ),
                      ControlPoint(
                        position: 1.0,
                        type: ControlPointType.transparent,
                      ),
                    ],
                  ),
                  EdgeBlur(
                    type: EdgeType.leftEdge,
                    size: 50.0,
                    sigma: 10.0,
                    controlPoints: [
                      ControlPoint(
                        position: 0.5,
                        type: ControlPointType.visible,
                      ),
                      ControlPoint(
                        position: 1.0,
                        type: ControlPointType.transparent,
                      ),
                    ],
                  ),
                  EdgeBlur(
                    type: EdgeType.bottomEdge,
                    size: 50.0,
                    sigma: 10.0,
                    controlPoints: [
                      ControlPoint(
                        position: 1.0,
                        type: ControlPointType.visible,
                      ),
                      ControlPoint(
                        position: 0.5,
                        type: ControlPointType.transparent,
                      ),
                    ],
                  ),
                  EdgeBlur(
                    type: EdgeType.rightEdge,
                    size: 50.0,
                    sigma: 10.0,
                    controlPoints: [
                      ControlPoint(
                        position: 0.5,
                        type: ControlPointType.transparent,
                      ),
                      ControlPoint(
                        position: 1.0,
                        type: ControlPointType.visible,
                      ),
                    ],
                  ),
                ],
                child: buildColorGrid(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SoftEdgeBlur),
        matchesGoldenFile('goldens/soft_edge_blur_multiple_edges.png'),
      );
    });
  });
}
