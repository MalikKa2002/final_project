import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  @override
  CustomBottomNavBarState createState() => CustomBottomNavBarState();
}

class CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      // color: Colors.black.withAlpha((0.2 * 255).toInt()),
      // color: const Color(0xFFA6B49E),
      shape: CircularNotchedRectangle(),
      notchMargin: 10.0,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.explore, size: 30),
            // Icon(Icons.bookmark_border, size: 30),
            SizedBox(width: 40), // Space for the FAB
            // Icon(Icons.notifications_outlined, size: 30),
            Icon(Icons.account_circle_outlined, size: 30),
          ],
        ),
      ),
    );
  }
}
