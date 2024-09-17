import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:soft_edge_blur/soft_edge_blur.dart';

void main() {
  testWidgets('SoftEdgeBlur builds without error', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SoftEdgeBlur(
            edges: [
              EdgeBlur(
                type: EdgeType.topEdge,
                size: 10.0,
                sigma: 5.0,
                controlPoints: [
                  ControlPoint(
                    position: 0.0,
                    type: ControlPointType.transparent,
                  ),
                  ControlPoint(
                    position: 1.0,
                    type: ControlPointType.visible,
                  ),
                ],
              ),
              EdgeBlur(
                type: EdgeType.bottomEdge,
                size: 10.0,
                sigma: 5.0,
                controlPoints: [
                  ControlPoint(position: 0.0, type: ControlPointType.visible),
                  ControlPoint(
                    position: 1.0,
                    type: ControlPointType.transparent,
                  ),
                ],
              ),
            ],
            child: Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );

    // Verify that the widget builds and the child is present
    expect(find.byType(SoftEdgeBlur), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets(
    'SoftEdgeBlur asserts when duplicate edge types are provided',
    (WidgetTester tester) async {
      // Expect an assertion error due to duplicate edge types
      expect(
        () async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SoftEdgeBlur(
                  edges: [
                    EdgeBlur(
                      type: EdgeType.topEdge,
                      size: 10.0,
                      sigma: 5.0,
                      controlPoints: [
                        ControlPoint(
                          position: 0.0,
                          type: ControlPointType.transparent,
                        ),
                        ControlPoint(
                          position: 1.0,
                          type: ControlPointType.visible,
                        ),
                      ],
                    ),
                    EdgeBlur(
                      type: EdgeType.topEdge, // Duplicate edge type
                      size: 20.0,
                      sigma: 10.0,
                      controlPoints: [
                        ControlPoint(
                          position: 0.0,
                          type: ControlPointType.transparent,
                        ),
                        ControlPoint(
                          position: 1.0,
                          type: ControlPointType.visible,
                        ),
                      ],
                    ),
                  ],
                  child: Container(),
                ),
              ),
            ),
          );
        },
        throwsAssertionError,
      );
    },
  );
}
