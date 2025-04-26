import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_guide/Buttons/login_up_but.dart';
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
import 'package:smart_guide/Services/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _obscurePassword = true; // Password visibility toggle

  Future<void> _loginUser() async {
    try {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      String? validationMessage =
          Validators.validateUsernameAndPassword(username, password);
      if (validationMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validationMessage)),
        );
        return;
      }
      // Check if username exists and get the corresponding email
      String? email = await _getEmailFromUsername(username);
      if (email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username not found. Please register.")),
        );
        return;
      }

      // Authenticate the user with the retrieved email
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to HomeScreen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Login successful!")),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed. Please try again.")),
      );
    }
  }

  // Method to get the email associated with a username
  Future<String?> _getEmailFromUsername(String username) async {
    QuerySnapshot query = await _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first["email"];
    }
    return null; // Username not found
  }

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
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/app.png',
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),

                      HeadingText('Welcome to Smart Guide', 29),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: BodyText(text: 'Username', fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        controller: _usernameController,
                        labelText: 'Username',
                        prefixIcon: Icons.person,
                        validator: Validators().validateUsername,
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: BodyText(text: 'Password', fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: Validators().validatePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
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
                                  builder: (context) => ForgotPasswordScreen()),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 30),
                      MainButton(
                        onPressed: _loginUser,
                        child: Text(
                          'Sign in ',
                          style: TextStyle(fontSize: 20.0),
                        ),
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
                      ),
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
