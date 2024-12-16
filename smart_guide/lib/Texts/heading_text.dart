import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  const HeadingText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
        fontSize: 50,
      ),
      textAlign: TextAlign.center,
    );
  }
}
