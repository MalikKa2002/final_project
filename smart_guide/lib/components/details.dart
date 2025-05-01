import 'package:flutter/material.dart';
import 'package:smart_guide/Texts/heading_title.dart';
import 'package:smart_guide/components/image_slider.dart';
import 'package:smart_guide/icons/bordered_icon_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsPart extends StatelessWidget {
  final String collegeName;
  final String location;
  final String phoneNumber;
  final String website;
  final bool isOpen;
  final String description;

  const DetailsPart({
    this.collegeName = "Azrieli College of Engineering",
    this.location = "Jerusalem, Israel",
    this.phoneNumber = "+972 2 1234567",
    this.website = "https://www.campusguideuni.com",
    this.isOpen = true,
    this.description =
        "Campus Guide University is a top-notch institution located in Jerusalem. "
            "It offers state-of-the-art facilities, modern classrooms, and a friendly learning environment. "
            "The college aims to provide the best education with a focus on innovation and technology.",
  });

  String _getOpenStatus() {
    final now = DateTime.now();
    final openingTime = DateTime(now.year, now.month, now.day, 7, 0); // 7:00 AM
    final closingTime =
        DateTime(now.year, now.month, now.day, 22, 0); // 10:00 PM

    if (now.isAfter(openingTime) && now.isBefore(closingTime)) {
      return 'OPEN';
    } else {
      return 'CLOSED';
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2, // Two tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Tabs Content
              Expanded(
                child: Column(
                  children: [
                    // Tab Bar SizedBox(height: 8),
                    HeadingTitle(collegeName, 24),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(location),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        BorderedIconButton(icon: Icons.phone, onPressed: () {}),
                        SizedBox(width: 8),
                        BorderedIconButton(
                            icon: Icons.language, onPressed: () {}),
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
                    SizedBox(height: 20),

                    TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Theme.of(context).primaryColor,
                      tabs: [
                        Tab(text: local.details),
                        Tab(text: local.daysAndHours),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Tab Views
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Details Tab: Shows the description
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(description),
                              ],
                            ),
                          ),
                          // Days & Hours Tab: Shows opening status and working hours
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Current Status: ${_getOpenStatus()}"),
                                SizedBox(height: 8),
                                Text("Working Hours:"),
                                SizedBox(height: 8),
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
      ),
    );
  }
}
