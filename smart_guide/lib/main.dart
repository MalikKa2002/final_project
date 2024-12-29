import 'package:flutter/material.dart';
import 'package:smart_guide/Screens/welcome_screen.dart';
import 'package:smart_guide/nav_bar.dart';

void main() {
  runApp(ARGuideApp());
}

class ARGuideApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      theme: ThemeData(fontFamily: 'Roboto'),
    );
  }
}
