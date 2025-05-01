import 'package:flutter/material.dart';
import 'package:smart_guide/components/details.dart';

import 'package:smart_guide/components/image_slider.dart';

class CollegeInfoScreen extends StatefulWidget {
  @override
  createState() => _CollegeInfoScreenState();
}

class _CollegeInfoScreenState extends State<CollegeInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ImageSlider(),
          SizedBox(height: 20),
          Expanded(child: DetailsPart()),
        ],
      ),
    );
  }
}
