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
  bool isPlaying = false;
  double values = 0.0;
  final player = AudioPlayer();

  Duration? duration = Duration(seconds: 0);
  void initplyer() async {
    await player.setSource(AssetSource('music.mp3'));

    duration = await player.getDuration();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initplyer();
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
                  image: AssetImage('assets/cover.jpg'),
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
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset('assets/cover.jpg'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Beethoven',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 6,
                    fontSize: 36.0,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(values / 60).floor()} : ${(values % 60).floor()}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 200,
                      child: Slider.adaptive(
                        onChangeEnd: (newvalue) async {
                          setState(() {});
                          await player
                              .seek(Duration(seconds: newvalue.toInt()));
                        },
                        min: 0.0,
                        value: values,
                        max: duration != null
                            ? duration!.inSeconds.toDouble()
                            : 214,
                        onChanged: (newvalue) {
                          setState(() {
                            values = newvalue;
                          });
                        },
                        activeColor: Colors.white,
                      ),
                    ),
                    Text(
                      duration != null
                          ? "${duration!.inMinutes} : ${duration!.inSeconds % 60}"
                          : "Loading...",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(60.0),
                    ),
                    border: Border.all(color: Colors.pink),
                    color: Colors.black26,
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (isPlaying) {
                        await player.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        await player.resume();
                        setState(() {
                          isPlaying = true;
                        });
                        player.onDurationChanged.listen((positioned) {
                          setState(() {
                            values = positioned.inSeconds.toDouble();
                          });
                        });
                        duration = await player.getDuration();
                        setState(() {});
                      }
                    },
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
