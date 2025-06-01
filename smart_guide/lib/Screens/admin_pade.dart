// lib/Screens/admin_page.dart

import 'package:flutter/material.dart';
// import 'package:smart_guide/components/request.dart'; // NOT USED HERE any more
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// ----------------------------------------
/// ADMIN PAGE (with Tabs: Request, Users, Campuses)
/// ----------------------------------------
class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(local.managerPage),
        automaticallyImplyLeading: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar (filter logic can be added to onChanged if needed)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: local.search,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    // OPTIONAL: Implement filtering if you like
                  },
                ),
              ),

              // Tab bar
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: local.request),
                  Tab(text: local.users),
                  Tab(text: local.buildings),
                ],
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),

          child: TabBarView(
            controller: _tabController,
            children: [
              // ───────────── (1) REQUEST TAB ─────────────
              RequestBody(),

              // ───────────── (2) USERS TAB ─────────────
              UsersTab(),

              // ───────────── (3) CAMPUSES TAB ─────────────
              CampusesTab(),
            ],
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------
/// (1) REQUEST TAB (Firebase-backed)
/// Streams from `waiting_to_approve` and lets admin Accept/Reject
/// ----------------------------------------
class RequestBody extends StatefulWidget {
  const RequestBody({super.key});

  @override
  createState() => _RequestBodyState();
}

class _RequestBodyState extends State<RequestBody> {
  final CollectionReference _waitingCollection =
      FirebaseFirestore.instance.collection('waiting_to_approve');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _campusesCollection =
      FirebaseFirestore.instance.collection('campuses');
  final CollectionReference _notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  /// Approve flow:
  /// 1. Create a notification doc with { user_id, approved: true, timestamp }
  /// 2. Delete the waiting_to_approve request immediately
  void _approveRequest(
      BuildContext context, String requestId, String userId) async {
    final local = AppLocalizations.of(context)!;

    try {
      // 1. Add to notifications
      await _notificationsCollection.add({
        'user_id': userId,
        'approved': true,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. Remove the waiting request
      await _waitingCollection.doc(requestId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.requestAccepted)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.errorAction)),
      );
    }
  }

  /// Reject flow:
  /// 1. Create a notification doc with { user_id, approved: false, timestamp }
  /// 2. Delete the campus from `campuses/{campusId}`
  /// 3. Delete the waiting_to_approve request immediately
  void _rejectRequest(BuildContext context, String requestId, String userId,
      String campusId) async {
    final local = AppLocalizations.of(context)!;

    try {
      // 1. Add to notifications
      await _notificationsCollection.add({
        'user_id': userId,
        'approved': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. Delete the whole campus
      await _campusesCollection.doc(campusId).delete();

      // 3. Remove the waiting request
      await _waitingCollection.doc(requestId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.requestRejected)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.errorAction)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: _waitingCollection.snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text(local.noRequestsFound));
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (ctx, index) {
            final doc = docs[index];
            final data = doc.data()! as Map<String, dynamic>;

            final requestId = doc.id;
            final userId = data['user_id'] as String? ?? '';
            final campusId = data['campus_id'] as String? ?? '';

            // If user_id or campus_id is empty, show a fallback
            if (userId.isEmpty || campusId.isEmpty) {
              return ListTile(
                title: Text(local.errorFetchingData),
                subtitle: const Text('Missing user_id or campus_id'),
              );
            }

            return FutureBuilder<List<DocumentSnapshot>>(
              future: Future.wait([
                _usersCollection.doc(userId).get(),
                _campusesCollection.doc(campusId).get(),
              ]),
              builder: (ctx2, snap2) {
                if (snap2.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text('Loading…'),
                    leading: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                if (!snap2.hasData || snap2.data == null || snap2.data!.length < 2) {
                  return ListTile(
                    title: Text(local.unknown),
                    subtitle: Text(local.errorFetchingData),
                  );
                }

                final userDoc = snap2.data![0];
                final campusDoc = snap2.data![1];

                final username = userDoc.exists
                    ? (userDoc.get('username') as String? ?? userId)
                    : userId;
                final campusName = campusDoc.exists
                    ? (campusDoc.get('college_name') as String? ?? campusId)
                    : campusId;

                // ── NEW: pull the list of album_images from campusDoc
                final albumImagesList = campusDoc.exists
                    ? (campusDoc.get('album_images') as List<dynamic>?)
                            ?.cast<String>() ??
                        []
                    : <String>[];

                return Card(
                  color: const Color.fromARGB(255, 235, 240, 233),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.green[200] ?? Colors.green,
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Campus name ───
                        Text(
                          campusName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),

                        // ─── Who requested it ───
                        Row(
                          children: [
                            const Icon(Icons.person, size: 18, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              local.byLabel(username), // e.g. "By: {username}"
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ─── NEW: show album images, if any ───
                        if (albumImagesList.isNotEmpty) ...[
                          SizedBox(
                            height: 80,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: albumImagesList.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (ctx3, idx3) {
                                final imgUrl = albumImagesList[idx3];
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imgUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ] else ...[
                          // If no album images, you can optionally show nothing or a placeholder.
                          // For now, we just add a small gap.
                          const SizedBox(height: 8),
                        ],

                        // ─── Action buttons ───
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.close, color: Colors.red),
                              label: Text(local.rejected),
                              onPressed: () =>
                                  _rejectRequest(context, requestId, userId, campusId),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check),
                              label: Text(local.accepted),
                              onPressed: () =>
                                  _approveRequest(context, requestId, userId),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// ----------------------------------------
/// (2) USERS TAB
/// Streams `users` collection and allows deleting each user.
/// ----------------------------------------
class UsersTab extends StatelessWidget {
  UsersTab({Key? key}) : super(key: key);

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> _deleteUser(
      BuildContext context, String userId, String? imageUrl) async {
    final local = AppLocalizations.of(context)!;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(local.confirmDelete),
        content: Text(local.confirmDeleteUser),
        actions: [
          TextButton(
            child: Text(local.cancel),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text(local.delete),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    if (shouldDelete != true) return;

    try {
      // 1. Delete user image from Storage if it exists
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final ref = FirebaseStorage.instance.refFromURL(imageUrl);
        await ref.delete();
      }
      // 2. Delete Firestore document
      await _usersCollection.doc(userId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.userDeleted)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.errorDeletingUser)),
      );
    }
    // NOTE: Deleting the actual Auth account requires Admin SDK or a Callable Cloud Function.
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: _usersCollection.snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text(local.noUsersFound));
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (ctx, index) {
            final doc = docs[index];
            final data = doc.data()! as Map<String, dynamic>;

            final username = data['username'] as String? ?? local.unknownUser;
            final email = data['email'] as String? ?? '';
            final imageUrl = data['imageUrl'] as String?;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                      ? NetworkImage(imageUrl)
                      : null,
                  child: (imageUrl == null || imageUrl.isEmpty)
                      ? Text(
                          username.isNotEmpty ? username[0].toUpperCase() : '?',
                        )
                      : null,
                ),
                title: Text(username),
                subtitle: Text(email),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(context, doc.id, imageUrl),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// ----------------------------------------
/// (3) CAMPUSES TAB
/// Streams `campuses` collection, shows name, cover image, and album images.
/// Tapping the cover image allows deletion of the entire campus (Storage + Firestore).
/// ----------------------------------------
class CampusesTab extends StatelessWidget {
  CampusesTab({Key? key}) : super(key: key);

  final CollectionReference _campusesCollection =
      FirebaseFirestore.instance.collection('campuses');

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: _campusesCollection.snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text(local.noCampusesPending));
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (ctx, index) {
            final doc = docs[index];
            final data = doc.data()! as Map<String, dynamic>;

            // Extract fields from each campus document:
            final campusId = doc.id;
            final campusName = data['college_name'] as String? ?? local.unknown;
            final coverImageUrl = data['cover_image'] as String? ?? '';
            final albumImagesList =
                (data['album_images'] as List<dynamic>?)?.cast<String>() ?? [];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ─── Campus Name ───
                    Text(
                      campusName,
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // ─── Cover Image (tap to delete campus) ───
                    GestureDetector(
                      onTap: () => _confirmAndDeleteCampus(
                        context,
                        campusId: campusId,
                        coverUrl: coverImageUrl,
                      ),
                      child: coverImageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                coverImageUrl,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      local.tapCoverToDelete,
                      style: TextStyle(color: Colors.red[700], fontSize: 12),
                    ),
                    const SizedBox(height: 12),

                    // ─── Album Images (if any) ───
                    if (albumImagesList.isNotEmpty) ...[
                      Text(
                        local.albumImages,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: albumImagesList.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (ctx2, idx2) {
                            final imgUrl = albumImagesList[idx2];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imgUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Text(
                        local.noImagesFound,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Prompts the admin to confirm campus deletion.
  /// If confirmed, deletes all Storage files under `campus_images/{campusId}`,
  /// then deletes the Firestore document at `campuses/{campusId}`.
  Future<void> _confirmAndDeleteCampus(
    BuildContext context, {
    required String campusId,
    required String coverUrl,
  }) async {
    final local = AppLocalizations.of(context)!;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(local.confirmDelete),
        content: Text(local.confirmDeleteCampus),
        actions: [
          TextButton(
            child: Text(local.cancel),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text(local.delete),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    if (shouldDelete != true) return;

    try {
      // 1. List all files under Storage path `campus_images/{campusId}`
      final storageFolder =
          FirebaseStorage.instance.ref('campus_images/$campusId');
      final listResult = await storageFolder.listAll();

      // 2. Delete each file
      for (final item in listResult.items) {
        await item.delete();
      }

      // 3. If any sub‐folders (unlikely), delete their contents too
      for (final prefix in listResult.prefixes) {
        final subList = await prefix.listAll();
        for (final subItem in subList.items) {
          await subItem.delete();
        }
      }

      // 4. Delete the Firestore document for the campus
      await FirebaseFirestore.instance
          .collection('campuses')
          .doc(campusId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.campusDeleted)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.errorDeletingCampus)),
      );
    }
  }
}
