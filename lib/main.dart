import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MusicPlayer());
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final player = AudioPlayer();

  Duration? duration;
  void initplyer() async {
    await player.setSource(AssetSource('music.mp3'));

    duration = await player.getDuration();
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor = Colors.transparent;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/cover.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 28,
                  sigmaY: 28,
                ),
                child: Container(
                  color: Colors.black26,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    appBarColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    BlendMode.srcIn,
                  ),
                  child: const Text('Music Player'),
                ),
                // Other app bar properties
              ),
            ),
          ],
        ),
      ),
    );
  }
}
