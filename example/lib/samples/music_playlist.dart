import 'package:flutter/material.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

class MusicPlayerHome extends StatefulWidget {
  const MusicPlayerHome({super.key});

  @override
  State<MusicPlayerHome> createState() => _MusicPlayerHomeState();
}

class _MusicPlayerHomeState extends State<MusicPlayerHome> {
  int _selectedIndex = 0;
  final List<Song> songs = [
    Song("The Innovators", "Walter Isaacson", "17:28",
        "https://picsum.photos/200"),
    Song("Sapiens: A Brief History of Humankind", "Yuval Noah Harari", "15:17",
        "https://picsum.photos/201"),
    Song("The Phoenix Project", "Gene Kim, Kevin Behr, George Spafford",
        "14:46", "https://picsum.photos/202"),
    Song("Algorithms to Live By", "Brian Christian, Tom Griffiths", "11:50",
        "https://picsum.photos/203"),
    Song("AI Superpowers", "Kai-Fu Lee", "9:28", "https://picsum.photos/204"),
    Song("The Lean Startup", "Eric Ries", "8:38", "https://picsum.photos/205"),
    Song("Zero to One", "Peter Thiel, Blake Masters", "4:50",
        "https://picsum.photos/206"),
    Song("Hooked", "Nir Eyal", "4:40", "https://picsum.photos/207"),
    Song("The Pragmatic Programmer", "David Thomas, Andrew Hunt", "9:22",
        "https://picsum.photos/208"),
    Song("Superintelligence", "Nick Bostrom", "14:17",
        "https://picsum.photos/209"),
    Song("Life 3.0", "Max Tegmark", "13:29", "https://picsum.photos/210"),
    Song("The Code Breaker", "Walter Isaacson", "16:04",
        "https://picsum.photos/211"),
    Song("Everybody Lies", "Seth Stephens-Davidowitz", "7:39",
        "https://picsum.photos/212"),
    Song("Permanent Record", "Edward Snowden", "11:31",
        "https://picsum.photos/213"),
    Song("The Age of AI", "Henry Kissinger, Eric Schmidt, Daniel Huttenlocher",
        "19:10", "https://picsum.photos/214"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.transparent,
      body: _buildBlurredEdge(),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'Songs', Icons.music_note),
              _buildNavItem(1, 'Artists', Icons.person_2_outlined),
              _buildNavItem(2, 'Albums', Icons.image_outlined),
            ],
          ),
        ),
      ),
    );
  }

  SoftEdgeBlur _buildBlurredEdge() {
    return SoftEdgeBlur(
      edges: [
        EdgeBlur(
          type: EdgeType.bottomEdge,
          size: 200,
          sigma: 30,
          tintColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
          controlPoints: [
            ControlPoint(
              position: 0.4,
              type: ControlPointType.visible,
            ),
            ControlPoint(
              position: 1.0,
              type: ControlPointType.transparent,
            ),
          ],
        )
      ],
      child: _buildContent(),
    );
  }

  Stack _buildContent() {
    return Stack(
      children: [
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    songs[index].imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.music_note, size: 50);
                    },
                  ),
                ),
                title: Text(songs[index].title),
                subtitle: Text(songs[index].artist),
                trailing: Text(songs[index].duration),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 50,
          ),
        )
      ],
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final isSlected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Durations.medium1,
            decoration: BoxDecoration(
              color: isSlected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Icon(
              icon,
              color: isSlected ? Colors.black : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSlected ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class Song {
  final String title;
  final String artist;
  final String duration;
  final String imageUrl;

  Song(this.title, this.artist, this.duration, this.imageUrl);
}
