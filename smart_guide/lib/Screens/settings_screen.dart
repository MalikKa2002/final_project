import 'package:flutter/material.dart';
import 'package:smart_guide/Screens/admin_pade.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
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
                    child: const Text('Change Avatar'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the changes here
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Give Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rate us:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {},
                  );
                }),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Your feedback',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle feedback submission here
              },
              child: const Text('Submit'),
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
            // Edit Profile Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Bryan Wolf',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'bryanwolf@gmail.com',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () => _showEditProfileDialog(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Help and Support Section
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.green),
              title: Text(local.helpAndSupport,
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                // Open email client for help and support
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Contact Support'),
                      content: const Text(
                          'Please contact us at: support@example.com'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(color: Colors.grey),

            // Give Feedback Section
            ListTile(
              leading: const Icon(Icons.feedback_outlined, color: Colors.green),
              title: Text(local.giveFeedback,
                  style: TextStyle(color: Colors.black)),
              onTap: () => _showFeedbackDialog(context),
            ),
            const Divider(color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.language_outlined, color: Colors.green),
              title:
                  Text(local.language, style: TextStyle(color: Colors.black)),
              onTap: () => _showFeedbackDialog(context),
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
