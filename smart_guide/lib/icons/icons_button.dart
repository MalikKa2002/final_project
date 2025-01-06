import 'package:flutter/material.dart';

class IconsButton extends StatelessWidget {
  const IconsButton({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: const Color.fromARGB(255, 5, 5, 5),
      ),
      onPressed: onPressed,
    );
  }
}
