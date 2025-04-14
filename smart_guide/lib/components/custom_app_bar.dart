// custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:smart_guide/Screens/admin_pade.dart';
import 'package:smart_guide/Screens/search_results_screen.dart';
import 'package:smart_guide/Texts/heading_text.dart';
import 'package:smart_guide/components/location_widget.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      onPressed: () {},
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const SettingsScreen()),
                    //     );
                    //   },
                    //   child: CircleAvatar(
                    //     radius: 20,
                    //     backgroundImage: AssetImage('assets/profile.png'),
                    //   ),
                    // ),

                    IconButton(
                      icon: Icon(Icons.account_circle_outlined, size: 30),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminPage()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            Text(
              "Welcome To",
              style: TextStyle(
                  fontSize: 20, color: const Color.fromARGB(255, 2, 2, 2)),
            ),
            HeadingText("AR Campus Guide", 26),

            SizedBox(height: 20),
            SearchScreen(),
          ],
        ),
      ),
    );
  }
}
