import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      // backgroundColor: Colors.white,
      padding: const EdgeInsets.only(bottom: 00),
      child: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Colors.green.shade200,
          items: [
            Icon(Icons.home),
            Icon(Icons.bookmark_border),
            SizedBox(
                height: 40, width: 40, child: Image.asset("assets/AR.png")),
            Icon(Icons.notifications),
            Icon(Icons.account_circle),
          ]),
    );
  }
}
