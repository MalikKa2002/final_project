import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavBar extends StatefulWidget {
  @override
  CustomBottomNavBarState createState() => CustomBottomNavBarState();
}

class CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius:
        //     BorderRadiusDirectional.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          colors: [
            Colors.green.withAlpha((0.4 * 255).toInt()), // Base green
            Colors.lightGreen.withAlpha((0.4 * 255).toInt()), // Softer green
            Colors.teal.withAlpha((0.4 * 255).toInt()), // Blue-green shade
            Colors.lime.withAlpha((0.4 * 255).toInt()), // Vibrant yellow-green
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.white
            .withAlpha((0.7 * 255).toInt()), // Make the bar itself transparent

        buttonBackgroundColor: Colors.transparent,
        height: 60,
        items: [
          Icon(Icons.explore),
          Icon(Icons.bookmark_border),
          SizedBox(
            height: 40,
            width: 40,
            child: Image.asset("assets/AR.png"),
          ),
          Icon(Icons.notifications_outlined),
          Icon(Icons.account_circle_outlined),
        ],
      ),
    );
  }
}
