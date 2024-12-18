import 'package:flutter/material.dart';
import 'package:smart_guide/Buttons/welcome_button.dart';
import 'package:smart_guide/Texts/body_text.dart';
import 'package:smart_guide/Texts/heading_text.dart';
import 'package:smart_guide/custom_text.dart';
import 'package:smart_guide/icons/icons_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.of(context).size.width * 0.1, // 10% of screen width
          vertical:
              MediaQuery.of(context).size.height * 0.05, // 5% of screen height
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Heading Text
            HeadingText('Welcome Back!'),

            // Body Text
            BodyText('welcome back we missed you'),
            const SizedBox(height: 40),

            // the user name  and the pasword
            Align(
              alignment: Alignment.centerLeft, // Aligns the text to the left
              child: BodyText('Username'),
            ),
            const SizedBox(height: 10),
            CustomText(
              controller: _usernameController,
              labelText: 'Username',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // password
            Align(
              alignment: Alignment.centerLeft, // Aligns the text to the left
              child: BodyText('Password'),
            ),
            const SizedBox(height: 10),
            CustomText(
              controller: _passwordController,
              labelText: 'Password',
              prefixIcon: Icons.lock,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            // THe sign in Button
            const SizedBox(height: 55),
            WelcomeButton(
              child: Text(
                'Sign in ',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                // Navigate or perform an action
                print('sign in');
              },
            ),
            const SizedBox(height: 20),

            ///
            BodyText('---Or continue with---'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconsButton(
                  icon: Icons.g_mobiledata_sharp,
                  onPressed: () {
                    // Navigate or perform an action
                    print('Button Pressed');
                  },
                ),
                IconsButton(
                  icon: Icons.apple,
                  onPressed: () {
                    // Navigate or perform an action
                    print('Button Pressed');
                  },
                ),
                IconsButton(
                  icon: Icons.facebook,
                  onPressed: () {
                    // Navigate or perform an action
                    print('Button Pressed');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
