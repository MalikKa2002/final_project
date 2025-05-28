import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'New Message',
      'body': 'You have a new message from John.',
      'type': 'message',
    },
    {
      'title': 'Request Approved',
      'body': 'Your request to add Building A was accepted.',
      'type': 'approved',
    },
    {
      'title': 'Request Rejected',
      'body':
          'Your request to update Room 205 was rejected. Reason: Incomplete details.',
      'type': 'rejected',
    },
    {
      'title': 'Event Reminder',
      'body': 'Don’t forget about the meeting tomorrow!',
      'type': 'reminder',
    },
  ];

  IconData _getIconForType(String type) {
    switch (type) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'message':
        return Icons.message;
      case 'reminder':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(local.notification),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final type = notification['type'] ?? 'default';
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(_getIconForType(type)),
              title: Text(notification['title']!),
              subtitle: Text(notification['body']!),
              onTap: () {
                // Optional: handle tap
              },
            ),
          );
        },
      ),
    );
  }
}
