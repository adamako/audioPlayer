import 'dart:io';

import 'package:audioplayer/widgets/tab_button.dart';
import 'package:audioplayer/widgets/tape_painter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

enum TapeStatus { initial, playing, pausing, stopping, choosing }

class Tape extends StatefulWidget {
  @override
  _TapeState createState() => _TapeState();
}

class _TapeState extends State<Tape> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TapeStatus _status = TapeStatus.initial;
  AudioPlayer _audioPlayer;
  String _url;
  String _title;
  double _currentPosition = 0.0;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    Tween<double> tween = Tween<double>(begin: 0.0, end: 1.0);
    tween.animate(_controller);
    _audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 300,
          height: 200,
          child: AnimatedBuilder(
            builder: (BuildContext context, Widget child) {
              return CustomPaint(
                painter: TapePainter(
                    rotationValue: _controller.value,
                    title: _title,
                    progress: _currentPosition),
              );
            },
            animation: _controller,
          ),
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TapeButton(
              icon: Icons.play_arrow,
              onTap: play,
              isTapped: _status == TapeStatus.playing,
            ),
            SizedBox(width: 8),
            TapeButton(
                icon: Icons.pause,
                onTap: pause,
                isTapped: _status == TapeStatus.pausing),
            SizedBox(width: 8),
            TapeButton(
                icon: Icons.stop,
                onTap: stop,
                isTapped: _status == TapeStatus.stopping),
            SizedBox(width: 8),
            TapeButton(
                icon: Icons.eject,
                onTap: choose,
                isTapped: _status == TapeStatus.choosing)
          ],
        )
      ],
    );
  }

  void stop() {
    setState(() {
      _status = TapeStatus.stopping;
      _currentPosition = 0.0;
    });
    _controller.stop();
    _audioPlayer.stop();
  }

  void pause() {
    setState(() {
      _status = TapeStatus.pausing;
    });
    _controller.stop();
    _audioPlayer.pause();
  }

  void play() async {
    if (_url == null) {
      return;
    }
    setState(() {
      _status = TapeStatus.playing;
    });
    _controller.repeat();
    _audioPlayer.play(_url);
  }

  void choose() async {
    if (_status == TapeStatus.playing || _status == TapeStatus.pausing) {
      stop();
    }

    setState(() {
      _status = TapeStatus.choosing;
    });
    File file = await FilePicker.getFile(type: FileType.audio);
    _url = file.path;
    await _audioPlayer.setUrl(_url, isLocal: true);

    final FlutterFFprobe _flutterFFprobe = FlutterFFprobe();
    Map<dynamic, dynamic> mediaInfo =
        await _flutterFFprobe.getMediaInformation(_url);

    int duration = mediaInfo['duration'];

    file.uri.toString().split('/').last;

    String title = file.uri.toString().split('/').last;
    String artist;

    if (mediaInfo['metadata'] != null) {
      title = mediaInfo['metadata']['title'];
      artist = mediaInfo['metadata']['artist'];
    }

    String completeTitle = artist == null ? title : "$artist - $title";

    _audioPlayer.onPlayerCompletion.listen((event) {
      stop();
    });

    _audioPlayer.onAudioPositionChanged.listen((event) {
      _currentPosition = event.inMilliseconds / duration;
    });

    setState(() {
      _title = completeTitle;
      _status = TapeStatus.initial;
    });

    play();
  }
}
