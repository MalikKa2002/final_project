import 'package:flutter/material.dart';

class HeadingTitle extends StatelessWidget {
  const HeadingTitle(this.text, this.fontSize, {super.key});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
      textAlign: TextAlign.left,
    );
  }
}
