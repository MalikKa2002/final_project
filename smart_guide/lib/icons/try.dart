import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Container(
        height: 50,
        width: 60,
        color: Color.fromARGB(255, 152, 226, 155),
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

//Color.fromARGB(255, 89, 95, 89),
