import 'package:flutter/material.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

class Wallpapers extends StatelessWidget {
  const Wallpapers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SoftEdgeBlur(
            edges: [
              EdgeBlur(
                type: EdgeType.topEdge,
                size: 180,
                sigma: 280,
                tileMode: TileMode.mirror,
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
              ),
            ],
            child: Container(
              color: const Color(0xFF2C2C2C),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                padding: const EdgeInsets.only(top: 180, left: 8, right: 8),
                children: const [
                  ArtItem(
                      title: 'Drama X',
                      imageUrl: 'https://i.imgur.com/SqL8xUM.png'),
                  ArtItem(
                      title: 'Edges II',
                      imageUrl: 'https://i.imgur.com/eaNQ0dV.png'),
                  ArtItem(
                      title: 'Savages',
                      imageUrl: 'https://i.imgur.com/MZgTOXi.png'),
                  ArtItem(
                      title: 'Aperture II',
                      imageUrl: 'https://i.imgur.com/fw0ZryH.png'),
                  ArtItem(
                      title: 'Raunch',
                      imageUrl: 'https://i.imgur.com/XanxWL9.png'),
                  ArtItem(
                      title: 'Chaos',
                      imageUrl: 'https://i.imgur.com/bMZdsQE.png'),
                  ArtItem(
                      title: 'Vivid',
                      imageUrl: 'https://i.imgur.com/tk8SneS.png'),
                  ArtItem(
                      title: 'Spectrum',
                      imageUrl: 'https://i.imgur.com/4mhVKLC.png'),
                  ArtItem(
                      title: 'Drama X',
                      imageUrl: 'https://i.imgur.com/SqL8xUM.png'),
                  ArtItem(
                      title: 'Edges II',
                      imageUrl: 'https://i.imgur.com/eaNQ0dV.png'),
                  ArtItem(
                      title: 'Savages',
                      imageUrl: 'https://i.imgur.com/MZgTOXi.png'),
                  ArtItem(
                      title: 'Aperture II',
                      imageUrl: 'https://i.imgur.com/fw0ZryH.png'),
                  ArtItem(
                      title: 'Raunch',
                      imageUrl: 'https://i.imgur.com/XanxWL9.png'),
                  ArtItem(
                      title: 'Chaos',
                      imageUrl: 'https://i.imgur.com/bMZdsQE.png'),
                  ArtItem(
                      title: 'Vivid',
                      imageUrl: 'https://i.imgur.com/tk8SneS.png'),
                  ArtItem(
                      title: 'Spectrum',
                      imageUrl: 'https://i.imgur.com/4mhVKLC.png'),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 28,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Abstract',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArtItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const ArtItem({Key? key, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black54,
              height: 45,
            ),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const Positioned(
            right: 8,
            bottom: 8,
            child: Icon(Icons.favorite_border, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
