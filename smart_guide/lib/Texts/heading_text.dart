import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  const HeadingText(this.text, this.fontSize, {super.key});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
      textAlign: TextAlign.center,
    );
  }
}
