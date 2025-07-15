import 'dart:ui';
import 'package:flutter/material.dart';

class BlurryCircleButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double blurIntensity;
  final VoidCallback onPressed;
  final double size;

  const BlurryCircleButton({
    super.key,
    required this.icon,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.black26,
    this.blurIntensity = 5.0,
    required this.onPressed,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: IconButton(
            icon: Icon(icon, color: iconColor),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
