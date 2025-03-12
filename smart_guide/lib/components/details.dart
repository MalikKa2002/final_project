import 'package:flutter/material.dart';
import 'package:smart_guide/components/image_slider.dart';
import 'package:smart_guide/icons/bordered_icon_button.dart';

class DetailsPart extends StatelessWidget {
  final String collegeName;
  final String location;
  final String phoneNumber;
  final String website;
  final bool isOpen;
  final String description;

  const DetailsPart({
    Key? key,
    this.collegeName = "Azrieli college of engineering jerusalem ",
    this.location = "Jerusalem, Israel",
    this.phoneNumber = "+972 2 1234567",
    this.website = "https://www.campusguideuni.com",
    this.isOpen = true,
    this.description =
        "Campus Guide University is a top-notch institution located in Jerusalem. "
            "It offers state-of-the-art facilities, modern classrooms, and a friendly learning environment. "
            "The college aims to provide the best education with a focus on innovation and technology.",
  }) : super(key: key);

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
          // College Information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // College Name
                Text(
                  collegeName,
                ),
                SizedBox(height: 4),
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                    ),
                    SizedBox(width: 4),
                    Text(
                      location,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Icons Row (Phone, Website, Open/Closed Status)
                Row(
                  children: [
                    BorderedIconButton(
                      icon: Icons.phone,
                      onPressed: () {},
                    ),
                    SizedBox(width: 8),
                    BorderedIconButton(
                      icon: Icons.language,
                      onPressed: () {},
                    ),
                    Spacer(),
                    Text(
                      _getOpenStatus(),
                      style: TextStyle(
                        fontSize: 16,
                        color: _getOpenStatus() == 'OPEN'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),
                // About Section
                Text(
                  "Details",
                ),
                SizedBox(height: 8),
                Text(
                  description,
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
