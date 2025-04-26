import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'New Message',
      'body': 'You have a new message from John.',
    },
    {
      'title': 'Event Reminder',
      'body': 'Don’t forget about the meeting tomorrow!',
    },
    {
      'title': 'Update Available',
      'body': 'A new version of the app is ready to install.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.notifications),
              title: Text(notification['title']!),
              subtitle: Text(notification['body']!),
              onTap: () {
                // Handle notification click
              },
            ),
          );
        },
      ),
    );
  }
}
