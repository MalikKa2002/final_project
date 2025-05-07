import 'package:flutter/material.dart';
import 'package:smart_guide/Language/language_switcher.dart';
import 'package:smart_guide/Screens/admin_pade.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loading = true;
  String _name = '';
  String _email = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    setState(() {
      _name = data['username'] as String? ?? '';
      _email = data['email'] as String? ?? user.email ?? '';
      _nameController.text = _name;
      _emailController.text = _email;
      _loading = false;
    });
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'username': _nameController.text.trim(),
      'email': _emailController.text.trim(),
    });

    setState(() {
      _name = _nameController.text.trim();
      _email = _emailController.text.trim();
    });

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final local = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(local.editProfile),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: local.name,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: local.email,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Avatar:'),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle avatar change
                    },
                    child: Text(local.changeAvatar),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(local.cancel),
            ),
            TextButton(
              onPressed: () {
                // Save the changes here
                Navigator.of(context).pop();
              },
              child: Text(local.save),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final local = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(local.giveFeedback),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(local.rateUs),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {
                      // Handle star rating logic here
                    },
                  );
                }),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: local.yourFeedback,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(local.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle feedback submission here
              },
              child: Text(local.submit),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text(local.settings, style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile card (static avatar)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: _showEditProfileDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Help & Support
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.green),
              title: Text(local.helpAndSupport,
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(local.contactSupport),
                      content:
                          Text('${local.pleaseContactUs}\nsupport@example.com'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(local.close),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(color: Colors.grey),

            // Feedback
            ListTile(
              leading: const Icon(Icons.feedback_outlined, color: Colors.green),
              title: Text(local.giveFeedback,
                  style: TextStyle(color: Colors.black)),
              onTap: () => _showFeedbackDialog,
            ),
            const Divider(color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.language_outlined, color: Colors.green),
              title:
                  Text(local.language, style: TextStyle(color: Colors.black)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(local.language),
                    content: LanguageSwitcher(),
                  ),
                );
              },
            ),
            const Divider(color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined,
                  color: Colors.green),
              title: Text(local.appaManager,
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                );
              },
            ),
            const Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
