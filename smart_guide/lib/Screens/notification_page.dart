// lib/Screens/notification_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  IconData _getIconForType(String type) {
    switch (type) {
      case 'approved':
        return Icons.check_circle_outlined;
      case 'rejected':
        return Icons.cancel_outlined;
      case 'message':
        return Icons.message_outlined;
      case 'reminder':
        return Icons.event_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(local.notification),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Center(
          child: Text(
            local.notSignedIn,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    final uid = currentUser.uid;
    final notificationsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(local.notification),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notificationsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                local.noNotifications,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final approved = data['approved'] as bool? ?? false;
              final reason = data['reason'] as String?;
              final Timestamp? ts = data['timestamp'] as Timestamp?;

              late final String titleText;
              late final String bodyText;
              late final String typeKey;

              if (approved) {
                typeKey = 'approved';
                titleText = local.requestAcceptedTitle;
                bodyText = local.requestAcceptedBody;
              } else {
                typeKey = 'rejected';
                titleText = local.requestRejectedTitle;
                if (reason != null && reason.isNotEmpty) {
                  bodyText = local.requestRejectedBody(reason);
                } else {
                  bodyText = local.requestRejectedBodyNoReason;
                }
              }

              String timeString = '';
              if (ts != null) {
                final date = ts.toDate();
                timeString =
                    '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
              }

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(
                    _getIconForType(typeKey),
                    color: approved ? Colors.green : Colors.red,
                    size: 28,
                  ),
                  title: Text(
                    titleText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(bodyText, style: const TextStyle(fontSize: 14)),
                      if (timeString.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          timeString,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ],
                  ),
                  isThreeLine: timeString.isNotEmpty,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () async {
                      try {
                        await doc.reference.delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(local.notificationDeleted)),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(local.errorDeletingNotification)),
                        );
                      }
                    },
                  ),
                  onTap: () {
                    // Optional: handle tap
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
