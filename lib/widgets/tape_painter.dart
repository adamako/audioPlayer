import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TapePainter extends CustomPainter {
  double holeRadius;
  Offset leftHolePosition;
  Offset rightHolePosition;
  Path leftHole;
  Path rightHole;
  Path centerWindowPath;

  Paint paintObject;
  Size size;
  Canvas canvas;

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    this.canvas = canvas;

    holeRadius = size.height / 12;
    paintObject = Paint();

    _initHoles();
    _initCenterWindow();
    _drawTape();
  }

  void _initCenterWindow() {
    Rect centerWindow = Rect.fromLTRB(size.width * 0.4, size.height * 0.37,
        size.width * 0.6, size.height * 0.55);
    centerWindowPath = Path()..addRect(centerWindow);
  }

  void _initHoles() {
    leftHolePosition = Offset(size.width * 0.3, size.height * 0.46);
    rightHolePosition = Offset(size.width * 0.7, size.height * 0.46);

    leftHole = Path()
      ..addOval(Rect.fromCircle(center: leftHolePosition, radius: holeRadius));

    rightHole = Path()
      ..addOval(Rect.fromCircle(center: rightHolePosition, radius: holeRadius));
  }

  void _drawTape() {
    RRect tape = RRect.fromRectAndRadius(
        Rect.fromLTRB(0, 0, size.width, size.height), Radius.circular(16));

    Path tapePath = Path()..addRRect(tape);
    tapePath = Path.combine(PathOperation.difference, tapePath, leftHole);
    tapePath = Path.combine(PathOperation.difference, tapePath, rightHole);
    tapePath =
        Path.combine(PathOperation.difference, tapePath, centerWindowPath);

    canvas.drawShadow(tapePath, Colors.black, 3.0, false);
    paintObject.color = Colors.black;
    paintObject.color = Color(0xff522f19).withOpacity(0.8);
    canvas.drawPath(tapePath, paintObject);
  }

  Path _cutCenterWindowIntoPath(Path path) {
    return Path.combine(PathOperation.difference, path, centerWindowPath);
  }

  _cutHolesIntoPath(Path path) {
    path = Path.combine(PathOperation.difference, path, leftHole);
    path = Path.combine(PathOperation.difference, path, rightHole);
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
