import 'package:flutter/material.dart';
import 'package:smart_guide/components/details.dart';
import 'package:smart_guide/components/image_slider.dart';

class CollegeInfoScreen extends StatefulWidget {
  @override
  _CollegeInfoScreenState createState() => _CollegeInfoScreenState();
}

class _CollegeInfoScreenState extends State<CollegeInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ImageSlider(),
            DetailsPart(),
          ],
        ),
      ),
    );
  }
}
