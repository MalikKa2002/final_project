import 'package:flutter/material.dart';

class BorderedIconButton extends StatelessWidget {
  const BorderedIconButton(
      {super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Container(
        height: 50,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 8, 8, 8), // Border color
            width: 2, // Border width
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        alignment: Alignment.center,
        child: Center(
          child: IconButton(
            icon: Icon(
              icon,
              color: const Color.fromARGB(255, 5, 5, 5),
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
