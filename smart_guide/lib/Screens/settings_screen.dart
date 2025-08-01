// lib/Screens/settings_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_guide/Language/language_switcher.dart';
import 'package:smart_guide/Screens/admin_pade.dart';
import 'package:smart_guide/Screens/home_screen.dart';
import 'package:smart_guide/components/accessibility_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _loading = true;
  String _name = '';
  String _email = '';
  String _phone = '';
  String _imageUrl = '';
  bool _isAdmin = false;
  bool _isWheelchairAccessible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        // If no document, fall back to Auth fields and defaults
        setState(() {
          _name = user.displayName ?? '';
          _email = user.email ?? '';
          _phone = '';
          _imageUrl = '';
          _isAdmin = false;
          _isWheelchairAccessible = false;
          _emailController.text = _email;
          _phoneController.text = _phone;
          _loading = false;
        });
        return;
      }

      final data = doc.data()!;

      // Role field (string “role”: “admin” or “user”)
      final roleValue = data['role'] as String? ?? 'user';

      setState(() {
        _name = data['username'] as String? ?? (user.displayName ?? '');
        _email = data['email'] as String? ?? (user.email ?? '');
        _phone = data['phone'] as String? ?? '';
        _imageUrl = data['imageUrl'] as String? ?? '';
        _isAdmin = (roleValue.toLowerCase() == 'admin');
        _isWheelchairAccessible = (data['accessibility'] as bool?) ?? false;

        _emailController.text = _email;
        _phoneController.text = _phone;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    }
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newEmail = _emailController.text.trim();
    final newPhone = _phoneController.text.trim();

    try {
      if (newEmail != _email) {
        await user.updateEmail(newEmail);
      }

      await _firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
        'phone': newPhone,
      });

      setState(() {
        _email = newEmail;
        _phone = newPhone;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final file = File(picked.path);
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() {
      _loading = true;
    });

    try {
      final storageRef = _storage.ref().child('users_images/${user.uid}.jpg');
      final uploadTask = storageRef.putFile(file);
      await uploadTask.whenComplete(() => null);
      final downloadUrl = await storageRef.getDownloadURL();

      await _firestore.collection('users').doc(user.uid).update({
        'imageUrl': downloadUrl,
      });

      setState(() {
        _imageUrl = downloadUrl;
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar updated')),
      );
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload avatar: $e')),
      );
    }
  }

  /// Whenever the user tries to pop (back), send them to HomeScreen instead.
  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green[400],
          title: Text(local.settings, style: const TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            },
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ───────────── Profile Card ─────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _imageUrl.isNotEmpty
                                ? NetworkImage(_imageUrl)
                                : const AssetImage('assets/profile.png')
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Username (read-only)
                                Text(
                                  _name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Email (read-only display here)
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
                            icon: const Icon(Icons.camera_alt, color: Colors.black),
                            onPressed: _pickAndUploadAvatar,
                            tooltip: local.changeAvatar,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ───────────── Editable Fields ─────────────
                    // Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: local.email,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),

                    // Phone
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: local.phoneNumber,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: Text(local.save),
                        onPressed: _updateProfile,
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: Colors.grey),

                    // ───────────── Help & Support ─────────────
                    ListTile(
                      leading: const Icon(Icons.help_outline, color: Colors.green),
                      title: Text(local.helpAndSupport,
                          style: const TextStyle(color: Colors.black)),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(local.contactSupport),
                              content: Text('${local.pleaseContactUs}\nsupport@example.com'),
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

                    // ───────────── Feedback ─────────────
                    ListTile(
                      leading: const Icon(Icons.feedback_outlined, color: Colors.green),
                      title: Text(local.giveFeedback,
                          style: const TextStyle(color: Colors.black)),
                      onTap: () {
                        // Open a dialog that lets the user pick stars + enter text,
                        // then save into Firestore.
                        showDialog(
                          context: context,
                          builder: (context) {
                            int selectedStars = 0;
                            final feedbackController = TextEditingController();

                            return StatefulBuilder(
                              builder: (context, setDialogState) {
                                return AlertDialog(
                                  title: Text(local.giveFeedback),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Star rating row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(5, (index) {
                                          return IconButton(
                                            icon: Icon(
                                              index < selectedStars
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                            ),
                                            onPressed: () {
                                              setDialogState(() {
                                                selectedStars = index + 1;
                                              });
                                            },
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 12),
                                      // Feedback text field
                                      TextField(
                                        controller: feedbackController,
                                        decoration: InputDecoration(
                                          labelText: local.yourFeedback,
                                          border: const OutlineInputBorder(),
                                        ),
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(local.cancel),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final user = _auth.currentUser;
                                        if (user == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(local.failedSaveFeedback)),
                                          );
                                          return;
                                        }

                                        final feedbackText = feedbackController.text.trim();

                                        try {
                                          await _firestore
                                              .collection('feedback')
                                              .add({
                                            'uid': user.uid,
                                            'username': _name,
                                            'stars': selectedStars,
                                            'message': feedbackText,
                                            'timestamp': FieldValue.serverTimestamp(),
                                          });

                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(local.feedbackSaved)),
                                          );
                                        } catch (e) {
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    '${local.failedSaveFeedback}: $e')),
                                          );
                                        }
                                      },
                                      child: Text(local.submit),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const Divider(color: Colors.grey),

                    // ───────────── Language ─────────────
                    ListTile(
                      leading: const Icon(Icons.language_outlined, color: Colors.green),
                      title: Text(local.language,
                          style: const TextStyle(color: Colors.black)),
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

                    // ───────────── Accessibility ─────────────
                    ListTile(
                      leading: const Icon(Icons.accessibility, color: Colors.green),
                      title: Text(
                        local.accessibilityOptions,
                        style: const TextStyle(color: Colors.black),
                      ),
                      trailing: Text(
                        _isWheelchairAccessible ? "ON" : "OFF",
                        style: TextStyle(
                          color: _isWheelchairAccessible ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AccessibilitySettingsScreen(
                            initialValue: _isWheelchairAccessible,
                            onChanged: (value) async {
                              setState(() {
                                _isWheelchairAccessible = value;
                              });
                              final user = _auth.currentUser;
                              if (user != null) {
                                await _firestore
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({'accessibility': value});
                              }
                            },
                          ),
                        );
                      },
                    ),
                    const Divider(color: Colors.grey),

                    // ───────────── Admin Tile ─────────────
                    if (_isAdmin) ...[
                      ListTile(
                        leading: const Icon(
                          Icons.admin_panel_settings_outlined,
                          color: Colors.green,
                        ),
                        title: Text(
                          local.appaManager,
                          style: const TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AdminPage()),
                          );
                        },
                      ),
                      const Divider(color: Colors.grey),
                    ],

                    // You can add more tiles here for all users…
                  ],
                ),
              ),
      ),
    );
  }
}
