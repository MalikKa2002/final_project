import 'package:flutter/material.dart';

class TextWithDivider extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color dividerColor;
  final double dividerThickness;
  final EdgeInsetsGeometry textPadding;

  const TextWithDivider({
    super.key,
    required this.text,
    this.fontSize = 15.0,
    this.dividerColor = Colors.grey,
    this.dividerThickness = 1.0,
    this.textPadding = const EdgeInsets.symmetric(horizontal: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left line
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: dividerThickness,
          ),
        ),
        // Text in the center
        Padding(
          padding: textPadding,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: const Color.fromARGB(255, 82, 74, 74),
            ),
          ),
        ),
        // Right line
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: dividerThickness,
          ),
        ),
      ],
    );
  }
}
