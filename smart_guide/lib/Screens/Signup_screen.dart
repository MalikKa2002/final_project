import 'package:flutter/material.dart';
import 'package:smart_guide/Buttons/login_up_but.dart';
import 'package:smart_guide/Buttons/main_button.dart';
import 'package:smart_guide/Buttons/secondary_button.dart';
import 'package:smart_guide/Screens/login_screen.dart';
import 'package:smart_guide/Services/auth_service.dart';
import 'package:smart_guide/Texts/body_text.dart';
import 'package:smart_guide/Texts/heading_text.dart';
import 'package:smart_guide/Texts/text_with_divider.dart';
import 'package:smart_guide/components/custom_text.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
                    horizontal: MediaQuery.of(context).size.width *
                        0.1, // 10% of screen width
                    vertical: MediaQuery.of(context).size.height *
                        0.02, // 5% of screen height
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HeadingText('Get Started Free', 40),
                      BodyText(
                        text: 'free forever. no limited to discover',
                        fontSize: 16,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: BodyText(text: 'Email address', fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        controller: _emailController,
                        labelText: 'yourname@gmail.com',
                        prefixIcon: Icons.email,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
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
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
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
                        prefixIcon: Icons.key,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      MainButton(
                        child: Text(
                          'Sign up',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          // Navigate or perform an action
                          print('sign up');
                        },
                      ),

                      const SizedBox(height: 20),
                      // another way to sign in
                      TextWithDivider(
                        text: 'Or sign up with',
                        fontSize: 15.0,
                        dividerColor: Colors.grey,
                        dividerThickness: 1.0,
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SquareTile(
                            text: 'Login with Google',
                            iconData: Icons
                                .g_mobiledata_outlined, // Use any of the predefined icons or custom ones
                            onTap: () => AuthService().signInWithGoogle(),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BodyText(
                              text: 'Already have an account?', fontSize: 14),
                          SecondaryButton(
                            child: Text('Login now'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ),
        );
      }),
    );
  }
}
