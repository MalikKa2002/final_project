import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_guide/Screens/destination.dart';
import 'package:smart_guide/components/place_selectionList.dart';

class MapWithBottomSheet extends StatelessWidget {
  final String campusId;
  const MapWithBottomSheet({Key? key, required this.campusId}) : super(key: key);

  IconData _iconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'cafeteria':
        return Icons.food_bank;
      case 'bathroom':
        return Icons.bathroom;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(children: [
        Destination(),
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('campuses')
              .doc(campusId)
              .snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snap.hasData || !snap.data!.exists) {
              return Center(child: Text(local.noDataFound));
            }

            final data = snap.data!.data() as Map<String, dynamic>;
            final raw = data['places'] as List<dynamic>? ?? [];
            final places = raw
                .whereType<String>()
                .map((label) => {
                      'label': label,
                      'icon': _iconForLabel(label),
                    })
                .toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.1,
              maxChildSize: 0.9,
              builder: (ctx, scrollCtrl) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      // handle
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView(
                            controller: scrollCtrl,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: local.whereToGo,
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              PlaceSelectionList(
                                places: places,
                                onSelected: (label) {
                                  print("Selected: \$label");
                                  // TODO: navigate or update map based on label
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ]),
    );
  }
}
