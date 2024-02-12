import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:os_simulation/models/icons.dart';
import 'package:os_simulation/providers/desktop_provider.dart';

class MusicPlayerWindow extends StatefulWidget {
  final DesktopIcon icon;
  final String musicUrl;

  const MusicPlayerWindow({
    Key? key,
    required this.icon,
    required this.musicUrl,
  }) : super(key: key);

  @override
  _MusicPlayerWindowState createState() => _MusicPlayerWindowState();
}

class _MusicPlayerWindowState extends State<MusicPlayerWindow> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  bool isMaximized = false;
  bool isMinimized = false;
  Offset position = const Offset(100, 100);
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        totalDuration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        currentPosition = newPosition;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        currentPosition = Duration.zero;
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void togglePlay() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(widget.musicUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void stopMusic() async {
    await audioPlayer.stop();
    setState(() {
      currentPosition = Duration.zero;
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double width = isMaximized ? screenWidth : 300;
    double height = isMaximized ? screenHeight : 200;

    if (isMinimized) {
      width = 200;
      height = 50;
    }

    return Positioned(
      left: isMinimized ? screenWidth - 200 : position.dx,
      top: isMinimized ? screenHeight - 50 : position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position = Offset(
                position.dx + details.delta.dx, position.dy + details.delta.dy);
          });
        },
        child: Material(
          color: Colors.transparent,
          elevation: 4,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 151, 105, 231),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildTitleBar(context),
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 48.0,
                          icon: const Icon(Icons.skip_previous),
                          color: Colors.white,
                          onPressed: () {
                            final newPosition =
                                currentPosition - const Duration(seconds: 10);
                            audioPlayer.seek(newPosition >= Duration.zero
                                ? newPosition
                                : Duration.zero);
                          },
                        ),
                        IconButton(
                          iconSize: 64.0,
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                          ),
                          color: Colors.white,
                          onPressed: togglePlay,
                        ),
                        IconButton(
                          iconSize: 48.0,
                          icon: const Icon(Icons.skip_next),
                          color: Colors.white,
                          onPressed: () {
                            final newPosition =
                                currentPosition + const Duration(seconds: 10);
                            if (newPosition < totalDuration) {
                              audioPlayer.seek(newPosition);
                            } else {
                              stopMusic();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Slider
                Slider(
                  activeColor: Colors.purple[400],
                  inactiveColor: Colors.grey,
                  min: 0,
                  max: totalDuration.inSeconds.toDouble(),
                  value: currentPosition.inSeconds
                      .toDouble()
                      .clamp(0, totalDuration.inSeconds.toDouble()),
                  onChanged: (value) {
                    final newPosition = Duration(seconds: value.toInt());
                    audioPlayer.seek(newPosition);
                  },
                ),
                // Track info
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    '${currentPosition.toString().split('.').first} / ${totalDuration.toString().split('.').first}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 30,
      decoration: BoxDecoration(
        color: Colors.purple[700],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.icon.label,
            style: const TextStyle(color: Colors.white),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.minimize, color: Colors.white),
                onPressed: () => setState(() => isMinimized = true),
              ),
              IconButton(
                icon: Icon(isMaximized ? Icons.crop_square : Icons.crop_7_5,
                    color: Colors.white),
                onPressed: () => setState(() => isMaximized = !isMaximized),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  audioPlayer.stop();
                  Provider.of<DesktopProvider>(context, listen: false)
                      .removeWindow(widget, widget.icon, context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
