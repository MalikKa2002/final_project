import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Colors.green.shade300,
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
