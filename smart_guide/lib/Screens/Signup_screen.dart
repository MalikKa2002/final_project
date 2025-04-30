import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_guide/Buttons/login_up_but.dart';
import 'package:smart_guide/Buttons/main_button.dart';
import 'package:smart_guide/Buttons/secondary_button.dart';
import 'package:smart_guide/Screens/login_screen.dart';
import 'package:smart_guide/Services/auth_service.dart';
import 'package:smart_guide/Texts/body_text.dart';
import 'package:smart_guide/Texts/heading_text.dart';
import 'package:smart_guide/Texts/text_with_divider.dart';
import 'package:smart_guide/components/custom_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _studyLocationController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _obscurePassword = true; // Password visibility state

  final String superAdminEmail = "admin@smartguide.com";
  final List<String> campusAdmins = ["campusadmin@campus.com"];

  Future<void> _registerUser() async {
    try {
      String username = _usernameController.text.trim();

      // **Check if username already exists**
      bool usernameExists = await _checkIfUsernameExists(username);
      if (usernameExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username is already taken. Choose another.")),
        );
        return; // Stop the registration process
      }

      // **Create user in Firebase Authentication**
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // **Determine User Role**
      String role = "user";
      if (_emailController.text.trim() == superAdminEmail) {
        role = "super_admin";
      } else if (campusAdmins.contains(_emailController.text.trim())) {
        role = "campus_admin";
      }

      // **Store user details in Firestore**
      await _firestore.collection("users").doc(userCredential.user?.uid).set({
        "username": username,
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "study_location": _studyLocationController.text.trim(),
        "role": role,
        "created_at": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration successful!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // **Method to check if username exists in Firestore**
  Future<bool> _checkIfUsernameExists(String username) async {
    QuerySnapshot query = await _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
    return query.docs.isNotEmpty; // Returns true if username already exists
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
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
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HeadingText(local.getStartedFree, 40),
                      BodyText(
                        text: local.freeForever,
                        fontSize: 16,
                      ),
                      const SizedBox(height: 40),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: BodyText(text: local.emailAddress, fontSize: 16),
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
                        child:
                            BodyText(text: 'Your Name (Unique)', fontSize: 16),
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
                        child: BodyText(text: local.phoneNumber, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        controller: _phoneController,
                        labelText: 'Your phone number',
                        prefixIcon: Icons.phone,
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                            BodyText(text: local.studyLocation, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        controller: _studyLocationController,
                        labelText: 'Your study location',
                        prefixIcon: Icons.school,
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: BodyText(text: local.password, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: local.password,
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
                      const SizedBox(height: 30),

                      MainButton(
                        onPressed: _registerUser,
                        child: Text(
                          local.signUp,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // another way to sign in
                      TextWithDivider(
                        text: local.orSignUpWith,
                        fontSize: 15.0,
                        dividerColor: Colors.grey,
                        dividerThickness: 1.0,
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: SquareTile(
                            text: local.loginWithGoogle,
                            iconData: Icons
                                .g_mobiledata_outlined, // Use any of the predefined icons or custom ones
                            onTap: () => AuthService().signInWithGoogle(),
                          )),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BodyText(
                              text: 'Already have an account?', fontSize: 14),
                          SecondaryButton(
                            child: Text(local.loginNow),
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
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
