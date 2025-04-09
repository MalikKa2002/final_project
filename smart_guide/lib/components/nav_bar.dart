import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onTabSelected;

  const CustomBottomNavBar({required this.onTabSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 10.0,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Left icon: Home (Explore)
            IconButton(
              icon: Icon(Icons.explore, size: 30),
              onPressed: () => onTabSelected(0),
            ),

            // Spacer for FAB in the middle
            SizedBox(width: 40),

            // Right icon: Profile
            IconButton(
              icon: Icon(Icons.account_circle_outlined, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FullProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FullProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('My full custom profile')),
    );
  }
}
