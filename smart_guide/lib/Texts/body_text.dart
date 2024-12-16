import 'package:flutter/material.dart';

class BodyText extends StatelessWidget {
  const BodyText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color.fromARGB(255, 22, 22, 22),
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      textAlign: TextAlign.center,
    );
  }
}
