import 'package:flutter/material.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoftEdgeBlur Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EdgeType _selectedEdge = EdgeType.topEdge;
  double _edgeSize = 100.0;
  double _blurSigma = 10.0;
  bool _isVerticalList = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoftEdgeBlur Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SoftEdgeBlur(
                edges: [
                  EdgeBlur(_selectedEdge, _edgeSize, _blurSigma),
                ],
                child: _isVerticalList
                    ? _buildVerticalImageList()
                    : _buildHorizontalAvatarList(),
              ),
            ),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildVerticalImageList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Image.network(
          'https://picsum.photos/seed/${index + 1}/1600/800',
          height: 200,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildHorizontalAvatarList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://picsum.photos/seed/${index + 1}/900/900',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Radio<EdgeType>(
                value: EdgeType.topEdge,
                groupValue: _selectedEdge,
                onChanged: (EdgeType? value) {
                  setState(() {
                    _selectedEdge = value!;
                  });
                },
              ),
              const Text('Top'),
              Radio<EdgeType>(
                value: EdgeType.bottomEdge,
                groupValue: _selectedEdge,
                onChanged: (EdgeType? value) {
                  setState(() {
                    _selectedEdge = value!;
                  });
                },
              ),
              const Text('bottom'),
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
            max: 20,
            divisions: 40,
            label: _blurSigma.toStringAsFixed(1),
            onChanged: (double value) {
              setState(() {
                _blurSigma = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
