import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  String audio;
  AudioPlayerWidget({super.key, required this.audio});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final player = AudioPlayer();

  Future<void> playAudioFromUrl(String url) async {
    await player.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.lightBlue[100],
      ),
      child: IconButton(
        onPressed: () {
          playAudioFromUrl(widget.audio);
        },
        icon: Icon(
          Icons.volume_up_rounded,
          color: Colors.blue[500],
          size: 30,
        ),
      ),
    );
  }
}
