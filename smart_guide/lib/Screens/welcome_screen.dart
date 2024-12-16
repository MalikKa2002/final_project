import 'package:flutter/material.dart';
import 'package:smart_guide/Buttons/welcome_button.dart';
import 'package:smart_guide/Texts/body_text.dart';
import 'package:smart_guide/Texts/heading_text.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        // padding: const EdgeInsets.all(80.0),
        // padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 80.0),
        padding: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.of(context).size.width * 0.1, // 10% of screen width
          vertical:
              MediaQuery.of(context).size.height * 0.1, // 5% of screen height
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Aligns to the center horizontally
          children: [
            // Heading Text
            HeadingText('Welcome'),
            const SizedBox(height: 5), // Adds space between texts

            // Body Text
            BodyText('Start a new'),
            BodyText('social advantages!'),
            const SizedBox(height: 50), // Adds space before the image

            // Image
            Image.asset(
              'assets/app.png',
              height: 400, // Adjust the size as needed
              width: 400,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 50), // Adds space before the button

            // Welcome Button
            WelcomeButton(
              child: Text('Get Started'),
              onPressed: () {
                // Navigate or perform an action
                print('Button Pressed');
              },
            ),
          ],
        ),
      ),
    );
  }
}