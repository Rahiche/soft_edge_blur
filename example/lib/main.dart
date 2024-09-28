import 'package:example/samples/music_playlist.dart';
import 'package:example/samples/wallpapers.dart';
import 'package:flutter/material.dart';
import 'package:example/samples/airbnb.dart';
import 'package:example/samples/map.dart';

void main() {
  runApp(const AppChooser());
}

class AppChooser extends StatelessWidget {
  const AppChooser({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoftEdgeBlur Demos',
      theme: ThemeData.dark(),
      home: const AppChooserHome(),
    );
  }
}

class AppChooserHome extends StatelessWidget {
  const AppChooserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose an App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AirbnbCardApp()),
                );
              },
              child: const Text('Airbnb Card App'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapApp()),
                );
              },
              child: const Text('Map App'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MusicPlayerHome(),
                  ),
                );
              },
              child: const Text('Music Playlist'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Wallpapers(),
                  ),
                );
              },
              child: const Text('Wallpapers'),
            ),
          ],
        ),
      ),
    );
  }
}
