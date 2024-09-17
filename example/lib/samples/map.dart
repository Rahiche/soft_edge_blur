import 'package:flutter/material.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

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
  final Set<EdgeType> _selectedEdges = {EdgeType.topEdge};
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
      controlPointsPerEdge[edge] = _controlPoints;
    }

    return Scaffold(
      body: Row(
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
                  });
                },
              ),
            ),
            DropdownButton<ControlPointType>(
              value: cp.type,
              items: ControlPointType.values.map((ControlPointType type) {
                return DropdownMenuItem<ControlPointType>(
                  value: type,
                  child: Text(type == ControlPointType.visible
                      ? 'Visible'
                      : 'Transparent'),
                );
              }).toList(),
              onChanged: (ControlPointType? newValue) {
                setState(() {
                  cp.type = newValue!;
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
          children: [
            Row(
              children: [
                Checkbox(
                  value: _selectedEdges.contains(EdgeType.topEdge),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedEdges.add(EdgeType.topEdge);
                      } else {
                        _selectedEdges.remove(EdgeType.topEdge);
                      }
                    });
                  },
                ),
                const Text('Top'),
                Checkbox(
                  value: _selectedEdges.contains(EdgeType.bottomEdge),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedEdges.add(EdgeType.bottomEdge);
                      } else {
                        _selectedEdges.remove(EdgeType.bottomEdge);
                      }
                    });
                  },
                ),
                const Text('Bottom'),
                Checkbox(
                  value: _selectedEdges.contains(EdgeType.leftEdge),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedEdges.add(EdgeType.leftEdge);
                      } else {
                        _selectedEdges.remove(EdgeType.leftEdge);
                      }
                    });
                  },
                ),
                const Text('Left'),
                Checkbox(
                  value: _selectedEdges.contains(EdgeType.rightEdge),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedEdges.add(EdgeType.rightEdge);
                      } else {
                        _selectedEdges.remove(EdgeType.rightEdge);
                      }
                    });
                  },
                ),
                const Text('Right'),
              ],
            ),
            Text('Edge Size: ${_edgeSize.round()}'),
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
            Text('Blur Sigma: ${_blurSigma.toStringAsFixed(1)}'),
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
            const Text('Control Points:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(_controlPoints.length, (index) {
                  return _buildControlPointControl(
                      index, _controlPoints[index]);
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
                      _controlPoints
                          .sort((a, b) => a.position.compareTo(b.position));
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
