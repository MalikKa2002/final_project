// home_body.dart
import 'package:flutter/material.dart';
import 'package:smart_guide/Screens/college_info_screen.dart.dart';
import 'package:smart_guide/components/university_card.dart';

import '../components/add_campus_card.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                  AddCampusCard(),
                ],
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollegeInfoScreen(
                            // title: 'Azrieli College',
                            // description:
                            //     'Azrieli College: A leading institution in technology and innovation.',
                            ),
                      ),
                    ),
                    child: UniversityCard(
                      imagePath: 'assets/azrieli_college.png',
                      title: 'Azrieli College',
                      distance: '2.8km away',
                      time: '32 mins',
                    ),
                  ),
                  SizedBox(height: 20),
                  UniversityCard(
                    imagePath: 'assets/hebrew_university.png',
                    title: 'Hebrew University',
                    distance: '2.8km away',
                    time: '32 mins',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
