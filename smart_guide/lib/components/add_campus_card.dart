import 'package:flutter/material.dart';
import 'package:smart_guide/Screens/form_screen.dart';

class AddCampusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 18),
      width: 50,
      height: 50,
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.green, width: 1),
      //   borderRadius: BorderRadius.circular(15), // Consistent radius
      //   color: Colors.white,
      // ),
      child: Column(
        children: [
          IconButton(
            splashRadius: 20,
            alignment: Alignment.center,
            padding: EdgeInsets.all(0),
            constraints: BoxConstraints(
              minWidth: 5,
              minHeight: 5,
            ),
            icon: Icon(
              Icons.add_rounded,
              color: Colors.green,
              size: 40,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormScreen(),
                ),
              );
            },
          ),

          // Text(
          //   "Add Campus",
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.green,
          //   ),
          // ),
        ],
      ),
    );
  }
}
