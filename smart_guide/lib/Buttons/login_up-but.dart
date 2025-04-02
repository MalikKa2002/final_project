import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final IconData iconData; // Icon data
  final String text; // Text to display
  final Function()? onTap;

  const SquareTile({
    super.key,
    required this.iconData, // Icon data
    required this.text, // Text to display
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center, // Center the content
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Align items in the center
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Icon(
              iconData, // Display the icon
              size: 30, // Icon size
            ),
            SizedBox(height: 8), // Add space between icon and text
            Text(
              text, // Display the text
              style: TextStyle(
                fontSize: 13, // Adjust text size
                fontWeight: FontWeight.bold, // Adjust font weight
                color: Colors.black, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
