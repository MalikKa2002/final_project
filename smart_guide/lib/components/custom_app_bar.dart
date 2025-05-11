// custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:smart_guide/Screens/chat_screen.dart';
import 'package:smart_guide/Screens/notification_page.dart';
import 'package:smart_guide/Screens/search_results_screen.dart';
import 'package:smart_guide/Texts/heading_text.dart';
import 'package:smart_guide/components/location_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Location and Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LocationWidget(),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.chat, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              Text(
                local.welcomeTo,
                style: TextStyle(
                    fontSize: 20, color: const Color.fromARGB(255, 2, 2, 2)),
              ),
              HeadingText(local.arCampusGuide, 24),

              SizedBox(height: 20),
              SearchScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
