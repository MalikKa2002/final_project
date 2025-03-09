import 'dart:ui';

import 'package:flutter/material.dart';

class UniversityCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String distance;
  final String time;

  const UniversityCard({
    required this.imagePath,
    required this.title,
    required this.distance,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 18,
            left: 8,
            right: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter:
                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur effect
                child: Container(
                  color: Colors.black45, // Semi-transparent black
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "$title\n$distance · $time",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddCampusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(20), // Consistent radius
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: Colors.green,
            size: 40,
          ),
          SizedBox(height: 8),
          Text(
            "Add Campus",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
