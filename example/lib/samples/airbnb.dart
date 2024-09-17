import 'package:flutter/material.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

class AirbnbCardApp extends StatelessWidget {
  const AirbnbCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AirbnbCardSample();
  }
}

class AirbnbCardSample extends StatefulWidget {
  const AirbnbCardSample({super.key});

  @override
  State<AirbnbCardSample> createState() => _AirbnbCardSampleState();
}

class _AirbnbCardSampleState extends State<AirbnbCardSample> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AirbnbCard(),
      ),
    );
  }
}

class AirbnbCard extends StatelessWidget {
  const AirbnbCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned.fill(child: _buildBlurredImage()),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'APPS WE LOVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Airbnb',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Discover a special home away from home.',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFE1B369),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5A5F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.home, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Airbnb',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Vacation Rentals & Experiences',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Open'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SoftEdgeBlur _buildBlurredImage() {
    return SoftEdgeBlur(
      edges: [
        EdgeBlur(
          type: EdgeType.bottomEdge,
          size: 110,
          sigma: 30,
          tintColor: const Color(0xFFE1B369).withOpacity(0.6),
          controlPoints: [
            ControlPoint(
              position: 0.7,
              type: ControlPointType.visible,
            ),
            ControlPoint(
              position: 1,
              type: ControlPointType.transparent,
            )
          ],
        )
      ],
      child: Image.network(
        'https://images.pexels.com/photos/280235/pexels-photo-280235.jpeg?auto=compress&cs=tinysrgb&w=630',
        fit: BoxFit.cover,
      ),
    );
  }
}
