import 'package:flutter/material.dart';
import 'package:smart_guide/Language/language_switcher.dart';
import 'package:smart_guide/Screens/admin_pade.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showEditProfileDialog(BuildContext context) {
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

  void _showFeedbackDialog(BuildContext context) {
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
                    onPressed: () {},
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
