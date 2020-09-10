import 'package:audioplayer/widgets/tape.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff9bf44),
      child: Center(child: Tape()),
    );
  }
}
