import 'package:flutter/material.dart';
import 'package:smart_guide/Buttons/login_up-but.dart';
import 'package:smart_guide/Buttons/main_button.dart';
import 'package:smart_guide/Buttons/secondary_button.dart';
import 'package:smart_guide/Screens/signup_screen.dart';
import 'package:smart_guide/Screens/forgot_password_screen.dart';
import 'package:smart_guide/Screens/home_screen.dart';
import 'package:smart_guide/Services/auth_service.dart';
// import 'package:smart_guide/Services/auth_service.dart';
import 'package:smart_guide/Texts/body_text.dart';
import 'package:smart_guide/Texts/heading_text.dart';
import 'package:smart_guide/Texts/text_with_divider.dart';
import 'package:smart_guide/components/custom_text.dart';
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
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                        0.03, // 5% of screen height
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Heading Text
                      HeadingText('Welcome Back!', 40),
                      // Body Text
                      BodyText(
                          text: 'welcome back we missed you', fontSize: 15),
                      const SizedBox(height: 40),
                      // username text field
                      // Aligns the text to the left
                      Align(
                        alignment: Alignment.centerLeft,
                        child: BodyText(text: 'Username', fontSize: 16),
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
                      // password text field
                      // Aligns the text to the left
                      Align(
                        alignment:
                            Alignment.centerLeft, // Aligns the text to the left
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

                      Align(
                        alignment: Alignment.centerRight,
                        child: SecondaryButton(
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()),
                              );

                              print('forget button Pressed');
                            }),
                      ),
                      // THe sign in Button

                      const SizedBox(height: 30),
                      MainButton(
                        child: Text(
                          'Sign in ',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                          // Navigate or perform an action
                          print('sign in');
                        },
                      ),
                      const SizedBox(height: 25),
                      // another way to sign in
                      TextWithDivider(
                        text: 'Or continue with',
                        fontSize: 15.0,
                        dividerColor: Colors.grey,
                        dividerThickness: 1.0,
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: SquareTile(
                            text: 'Login with Google',
                            iconData: Icons
                                .g_mobiledata_outlined, // Use any of the predefined icons or custom ones
                            onTap: () => AuthService().signInWithGoogle(),
                          )),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BodyText(text: 'Not a member?', fontSize: 15),
                          SecondaryButton(
                            child: Text('Register Now'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()),
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
        },
      ),
    );
  }
}
