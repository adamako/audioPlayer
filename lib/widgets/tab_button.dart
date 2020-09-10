import 'package:flutter/material.dart';

class TapeButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  final bool isTapped;

  const TapeButton({this.icon, this.onTap, this.isTapped});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: isTapped ? 53.2 : 56,
        height: isTapped ? 60.8 : 64,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Center(
          child: Icon(icon, color: Colors.white),
        ),
      ),
      onTap: onTap,
    );
  }
}
