import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Forgot Password?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Enter your email address below, and we’ll send you instructions to reset your password.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                labelText: "Email Address",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
         ElevatedButton(
        onPressed: () {
            // Handle password reset functionality
        },
    style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Updated: Use backgroundColor instead of primary
            minimumSize: Size(double.infinity, 50), // Full-width button
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
           ),
          ),
          child: Text(
          "Send Instructions",
          style: TextStyle(fontSize: 16,color: Colors.white),
          ),
        ),

          ],
        ),
      ),
    );
  }
}

