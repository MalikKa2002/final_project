import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_guide/Buttons/main_button.dart';
import 'package:smart_guide/Buttons/secondary_button.dart';
import 'package:smart_guide/Screens/login_screen.dart';
import 'package:smart_guide/Texts/body_text.dart';
import 'package:smart_guide/Texts/heading_text.dart';
import 'package:smart_guide/Texts/text_with_divider.dart';
import 'package:smart_guide/components/custom_text.dart';
import 'package:smart_guide/icons/icons_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to handle user registration
  Future<void> _registerUser() async {
    try {
      // Create a user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Optionally, update the display name with username
      await userCredential.user?.updateDisplayName(_usernameController.text.trim());

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration successful!")),
      );

      // Navigate to login screen or next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      // Show error message if registration fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1, // 10% of screen width
                  vertical: MediaQuery.of(context).size.height * 0.02, // 2% of screen height
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HeadingText('Get Started Free'),
                    BodyText(
                      text: 'Free forever. No limits to discover.',
                      fontSize: 16,
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BodyText(text: 'Email address', fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      controller: _emailController,
                      labelText: 'yourname@gmail.com',
                      prefixIcon: Icons.email,
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BodyText(text: 'Your Name', fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      controller: _usernameController,
                      labelText: '@yourname',
                      prefixIcon: Icons.person,
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BodyText(text: 'Password', fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      controller: _passwordController,
                      labelText: 'Password',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    MainButton(
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: _registerUser,
                    ),
                    const SizedBox(height: 20),
                    TextWithDivider(
                      text: 'Or sign up with',
                      fontSize: 15.0,
                      dividerColor: Colors.grey,
                      dividerThickness: 1.0,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconsButton(
                          icon: Icons.g_mobiledata_sharp,
                          onPressed: () {
                            print('Google signup coming soon');
                          },
                        ),
                        IconsButton(
                          icon: Icons.facebook,
                          onPressed: () {
                            print('Facebook signup coming soon');
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BodyText(
                          text: 'Already have an account?',
                          fontSize: 14,
                        ),
                        SecondaryButton(
                          child: const Text('Login now'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
