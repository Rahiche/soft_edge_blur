import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<EdgeType> _selectedEdges = {EdgeType.topEdge};
  double _edgeSize = 100.0;
  double _blurSigma = 20.0;

  final List<ControlPoint> _controlPoints = [
    ControlPoint(position: 0.0, type: ControlPointType.visible),
    ControlPoint(position: 1.0, type: ControlPointType.transparent),
  ];

  @override
  Widget build(BuildContext context) {
    // Adjust control points for Right and Bottom edges
    Map<EdgeType, List<ControlPoint>> controlPointsPerEdge = {};

    for (var edge in _selectedEdges) {
      List<ControlPoint> controlPointsToUse = _controlPoints;
      if (edge == EdgeType.rightEdge || edge == EdgeType.bottomEdge) {
        controlPointsToUse = _controlPoints.map((cp) {
          return ControlPoint(
            position: 1.0 - cp.position,
            type: cp.type,
          );
        }).toList();
      }
      controlPointsPerEdge[edge] = controlPointsToUse;
    }
    var theme = Theme.of(context);
    return Scaffold(
      body: Theme(
        data: theme.copyWith(
          sliderTheme: SliderThemeData(
            overlayShape: SliderComponentShape.noThumb,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: SoftEdgeBlur(
                edges: _selectedEdges.map((edge) {
                  return EdgeBlur(
                    type: edge,
                    size: _edgeSize,
                    sigma: _blurSigma,
                    controlPoints: controlPointsPerEdge[edge]!,
                  );
                }).toList(),
                child: _buildMap(),
              ),
            ),
            Expanded(child: _buildControls()),
          ],
        ),
      ),
    );
  }

  FlutterMap _buildMap() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(51.5, -0.09),
        initialZoom: 18,
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            const LatLng(-90, -180),
            const LatLng(90, 180),
          ),
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          tileBuilder: darkModeTileBuilder,
        ),
        RichAttributionWidget(
          popupInitialDisplayDuration: const Duration(seconds: 5),
          animationConfig: const ScaleRAWA(),
          showFlutterMapAttribution: false,
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () {},
            ),
            const TextSourceAttribution(
              'This attribution is the same throughout this app, except '
              'where otherwise specified',
              prependCopyright: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlPointControl(int index, ControlPoint cp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Control Point ${index + 1}'),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: cp.position,
                min: 0.0,
                max: 1.0,
                divisions: 100,
                label: cp.position.toStringAsFixed(2),
                onChanged: (double value) {
                  setState(() {
                    cp.position = value;
                    _controlPoints.sort((a, b) => a.position.compareTo(b.position));
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(cp.type == ControlPointType.visible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _controlPoints.add(
                    ControlPoint(
                      position: 0.5,
                      type: ControlPointType.visible,
                    ),
                  );
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _controlPoints.removeAt(index);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Blur position'),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton(
                multiSelectionEnabled: true,
                selected: _selectedEdges,
                segments: const [
                  ButtonSegment(
                    value: EdgeType.topEdge,
                    label: Text('Top'),
                  ),
                  ButtonSegment(
                    value: EdgeType.bottomEdge,
                    label: Text('Bottom'),
                  ),
                  ButtonSegment(
                    value: EdgeType.leftEdge,
                    label: Text('Left'),
                  ),
                  ButtonSegment(
                    value: EdgeType.rightEdge,
                    label: Text('Right'),
                  ),
                ],
                onSelectionChanged: (Set<EdgeType> selectedEdges) {
                  setState(() {
                    _selectedEdges = selectedEdges;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Edge Size: ${_edgeSize.round()}'),
            const SizedBox(height: 8),
            Slider(
              value: _edgeSize,
              min: 0,
              max: 200,
              divisions: 20,
              label: _edgeSize.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _edgeSize = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Text('Blur Sigma: ${_blurSigma.toStringAsFixed(1)}'),
            const SizedBox(height: 8),
            Slider(
              value: _blurSigma,
              min: 0,
              max: 40,
              divisions: 40,
              label: _blurSigma.toStringAsFixed(1),
              onChanged: (double value) {
                setState(() {
                  _blurSigma = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Control Points', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(_controlPoints.length, (index) {
                  return _buildControlPointControl(index, _controlPoints[index]);
                }),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _controlPoints.add(
                        ControlPoint(
                          position: 0.5,
                          type: ControlPointType.visible,
                        ),
                      );
                      _controlPoints.sort((a, b) => a.position.compareTo(b.position));
                    });
                  },
                  child: const Text('Add Control Point'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
