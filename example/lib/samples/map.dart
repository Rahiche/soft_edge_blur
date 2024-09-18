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

  List<ControlPoint> _controlPoints = [
    ControlPoint(position: 0.0, type: ControlPointType.visible),
    ControlPoint(position: 1.0, type: ControlPointType.transparent),
  ];

  @override
  Widget build(BuildContext context) {
    final isSmallDevice = MediaQuery.of(context).size.width < 900;

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
                  controlPoints: _controlPoints,
                );
              }).toList(),
              child: _buildMap(),
            ),
          ),
          if (!isSmallDevice) Expanded(child: _buildControlsSheet()),
        ],
      ),
      floatingActionButton: isSmallDevice
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Use the default background color
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Theme(
                        data: Theme.of(context), // Use the current theme

                        child: _buildControlsSheet());
                  },
                );
              },
              child: const Icon(Icons.settings),
            )
          : null,
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

  Widget _buildControlsSheet() {
    return ControlsSheet(
      selectedEdges: _selectedEdges,
      controlPoints: _controlPoints,
      edgeSize: _edgeSize,
      blurSigma: _blurSigma,
      onEdgesChanged: (Set<EdgeType> selectedEdges) {
        setState(() {
          _selectedEdges = selectedEdges;
        });
      },
      onEdgeSizeChanged: (double edgeSize) {
        setState(() {
          _edgeSize = edgeSize;
        });
      },
      onBlurSigmaChanged: (double blurSigma) {
        setState(() {
          _blurSigma = blurSigma;
        });
      },
      onControlPointsChanged: (List<ControlPoint> controlPoints) {
        setState(() {
          _controlPoints = List.from(controlPoints);
        });
      },
      onUpdate: () {
        setState(() {});
      },
    );
  }
}

class ControlsSheet extends StatefulWidget {
  final Set<EdgeType> selectedEdges;
  final List<ControlPoint> controlPoints;
  final double edgeSize;
  final double blurSigma;
  final ValueChanged<Set<EdgeType>> onEdgesChanged;
  final ValueChanged<double> onEdgeSizeChanged;
  final ValueChanged<double> onBlurSigmaChanged;
  final ValueChanged<List<ControlPoint>> onControlPointsChanged; // Add this callback
  final VoidCallback onUpdate;

  const ControlsSheet({
    super.key,
    required this.selectedEdges,
    required this.controlPoints,
    required this.edgeSize,
    required this.blurSigma,
    required this.onEdgesChanged,
    required this.onEdgeSizeChanged,
    required this.onBlurSigmaChanged,
    required this.onControlPointsChanged, // Include in constructor
    required this.onUpdate,
  });

  @override
  State<ControlsSheet> createState() => _ControlsSheetState();
}

class _ControlsSheetState extends State<ControlsSheet> {
  late Set<EdgeType> _localSelectedEdges;
  late List<ControlPoint> _localControlPoints;
  late double _localEdgeSize;
  late double _localBlurSigma;

  @override
  void initState() {
    super.initState();
    _localSelectedEdges = widget.selectedEdges;
    _localControlPoints = List.from(widget.controlPoints);
    _localEdgeSize = widget.edgeSize;
    _localBlurSigma = widget.blurSigma;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        sliderTheme: SliderThemeData(
          overlayShape: SliderComponentShape.noThumb,
        ),
      ),
      child: Container(
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
                  showSelectedIcon: false,
                  selected: _localSelectedEdges,
                  segments: const [
                    ButtonSegment(value: EdgeType.topEdge, label: Text('Top')),
                    ButtonSegment(value: EdgeType.bottomEdge, label: Text('Bottom')),
                    ButtonSegment(value: EdgeType.leftEdge, label: Text('Left')),
                    ButtonSegment(value: EdgeType.rightEdge, label: Text('Right')),
                  ],
                  onSelectionChanged: (Set<EdgeType> selectedEdges) {
                    setState(() {
                      _localSelectedEdges = selectedEdges;
                    });
                    widget.onEdgesChanged(selectedEdges);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text('Edge Size: ${_localEdgeSize.round()}'),
              const SizedBox(height: 8),
              Slider(
                value: _localEdgeSize,
                min: 0,
                max: 200,
                divisions: 20,
                label: _localEdgeSize.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _localEdgeSize = value;
                  });
                  widget.onEdgeSizeChanged(value);
                },
              ),
              const SizedBox(height: 8),
              Text('Blur Sigma: ${_localBlurSigma.toStringAsFixed(1)}'),
              const SizedBox(height: 8),
              Slider(
                value: _localBlurSigma,
                min: 0,
                max: 40,
                divisions: 40,
                label: _localBlurSigma.toStringAsFixed(1),
                onChanged: (double value) {
                  setState(() {
                    _localBlurSigma = value;
                  });
                  widget.onBlurSigmaChanged(value);
                },
              ),
              const SizedBox(height: 32),
              const Text('Control Points', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(_localControlPoints.length, (index) {
                    return _buildControlPointControl(index);
                  }),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _localControlPoints.add(
                          ControlPoint(position: 0.5, type: ControlPointType.visible),
                        );
                        widget.onControlPointsChanged(_localControlPoints);
                      });
                    },
                    child: const Text('Add Control Point'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlPointControl(int index) {
    final cp = _localControlPoints[index];
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
                    _localControlPoints.sort((a, b) => a.position.compareTo(b.position));
                    widget.onControlPointsChanged(_localControlPoints);
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(cp.type == ControlPointType.visible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  cp.type =
                      cp.type == ControlPointType.visible ? ControlPointType.transparent : ControlPointType.visible;
                  widget.onControlPointsChanged(_localControlPoints);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _localControlPoints.removeAt(index);
                  widget.onControlPointsChanged(_localControlPoints);
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
