// home_body.dart
import 'package:flutter/material.dart';
import 'package:smart_guide/components/university_card.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String displayedInfo =
      "Welcome to AR Campus Guide! This app helps you navigate campuses and find your way with ease.";

  void updateInfo(String newInfo) {
    setState(() {
      displayedInfo = newInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Universities & Colleges Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Universities & Colleges",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Horizontal Cards Section
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () => updateInfo(
                        "Azrieli College: A leading institution in technology and innovation.",
                      ),
                      child: UniversityCard(
                        imagePath: 'assets/azrieli_college.png',
                        title: 'Azrieli College',
                        distance: '2.8km away',
                        time: '32 mins',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => updateInfo(
                        "Hebrew University: Known for excellence in education and research.",
                      ),
                      child: UniversityCard(
                        imagePath: 'assets/hebrew_university.png',
                        title: 'Hebrew University',
                        distance: '2.8km away',
                        time: '32 mins',
                      ),
                    ),
                    AddCampusCard(), // Add Campus button styled as a card
                    SizedBox(width: 16), // Add space at the end
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Information Display Section
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "About",
              //         style: TextStyle(
              //           fontSize: 24,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.green,
              //         ),
              //       ),
              //       SizedBox(height: 10),
              //       Text(
              //         displayedInfo,
              //         style: TextStyle(
              //           fontSize: 16,
              //           color: Colors.black87,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
