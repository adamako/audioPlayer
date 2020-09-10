import 'package:audioplayer/widgets/tape_painter.dart';
import 'package:flutter/material.dart';

class Tape extends StatefulWidget {
  @override
  _TapeState createState() => _TapeState();
}

class _TapeState extends State<Tape> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    Tween<double> tween = Tween<double>(begin: 0.0, end: 1.0);
    tween.animate(_controller);
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
                painter: TapePainter(),
              );
            },
            animation: _controller,
          ),
        )
      ],
    );
  }

  void stop() {}
  void pause() {}
  void play() {}
  void choose() {}
}
