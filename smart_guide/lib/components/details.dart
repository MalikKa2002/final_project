import 'package:flutter/material.dart';
import 'package:smart_guide/Texts/heading_title.dart';
import 'package:smart_guide/icons/bordered_icon_button.dart';

class DetailsPart extends StatelessWidget {
  final String collegeName;
  final String location;
  final String phoneNumber;
  final String website;
  final bool isOpen;
  final String description;

  const DetailsPart(
      {this.collegeName = "Azrieli college of engineering  ",
      this.location = "Jerusalem, Israel",
      this.phoneNumber = "+972 2 1234567",
      this.website = "https://www.campusguideuni.com",
      this.isOpen = true,
      this.description =
          "Campus Guide University is a top-notch institution located in Jerusalem. "
              "It offers state-of-the-art facilities, modern classrooms, and a friendly learning environment. "
              "The college aims to provide the best education with a focus on innovation and technology. "});

  // void _makePhoneCall(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // void _openWebsite(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // College Info remains the same...
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingTitle(collegeName, 24),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(location),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    BorderedIconButton(icon: Icons.phone, onPressed: () {}),
                    SizedBox(width: 8),
                    BorderedIconButton(icon: Icons.language, onPressed: () {}),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Text(
                        _getOpenStatus(),
                        style: TextStyle(
                          fontSize: 20,
                          color: _getOpenStatus() == 'OPEN'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // 🆕 Tabs Section
                DefaultTabController(
                  length: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Theme.of(context).primaryColor,
                        tabs: [
                          Tab(text: "Details"),
                          Tab(text: "Days & Hours"),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 120, // adjust based on your content
                        child: TabBarView(
                          children: [
                            // Details Tab
                            SingleChildScrollView(
                              child: Text(description),
                              // Work & Hours Tab
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Current Status: ${_getOpenStatus()}"),
                                  Text("Working Hours:"),
                                  Text("Sunday - Thursday: 7:00 AM - 10:00 PM"),
                                  Text("Friday: 7:00 AM - 1:00 PM"),
                                  Text("Saturday: Closed"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Function to check if the college is open or closed
String _getOpenStatus() {
  final now = DateTime.now();
  final openingTime = DateTime(now.year, now.month, now.day, 7, 0); // 9:00 AM
  final closingTime = DateTime(now.year, now.month, now.day, 22, 0); // 5:00 PM

  if (now.isAfter(openingTime) && now.isBefore(closingTime)) {
    return 'OPEN';
  } else {
    return 'CLOSED';
  }
}
