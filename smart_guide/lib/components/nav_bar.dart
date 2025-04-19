import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onTabSelected;

  const CustomBottomNavBar({required this.onTabSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      height: 60,
      // color: const Color.fromARGB(255, 232, 245, 232),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Left icon: Home (Explore)
            IconButton(
              icon: Icon(Icons.explore_outlined, size: 30),
              onPressed: () => onTabSelected(0),
            ),

            // Spacer for FAB in the middle
            SizedBox(width: 40),

            // Right icon: Profile
            IconButton(
              icon: Icon(Icons.account_circle_outlined, size: 30),
              onPressed: () => onTabSelected(1),
            ),
          ],
        ),
      ),
    );
  }
}
