// lib/Screens/college_info_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_guide/components/details.dart';
import 'package:smart_guide/components/image_slider.dart';
import 'package:smart_guide/components/nav_bar.dart'; // if you still show the bottom nav
import 'package:smart_guide/Screens/settings_screen.dart';
import 'package:smart_guide/components/draggable_scrollable_sheet.dart'; // MapWithBottomSheet

class CollegeInfoScreen extends StatefulWidget {
  final String campusId;
  final VoidCallback onBack;

  const CollegeInfoScreen({
    required this.campusId,
    required this.onBack,
    super.key,
  });

  @override
  State<CollegeInfoScreen> createState() => _CollegeInfoScreenState();
}

class _CollegeInfoScreenState extends State<CollegeInfoScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pop(context);
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MapWithBottomSheet()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SettingsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('campuses')
            .doc(widget.campusId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text(local.noDataFound));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          // ← CHANGE #1: read "phone" and "website" (instead of "phone_number")
          final String phoneNumber = (data['phone'] as String?)?.trim() ?? '';
          final String website     = (data['website'] as String?)?.trim() ?? '';

          final String name        = (data['college_name'] as String?)?.trim() ?? '';
          final String location    = (data['location'] as String?)?.trim() ?? '';
          final String description = (data['description'] as String?)?.trim() ?? '';

          // gallery_images array:
          final List<String> gallery = <String>[];
          if (data['gallery_images'] is List) {
            for (var element in (data['gallery_images'] as List)) {
              if (element is String) gallery.add(element);
            }
          }

          // opening_hours map:
          final Map<String, dynamic> rawHours = 
              data['operating_hours'] is Map 
                ? Map<String, dynamic>.from(data['operating_hours']) 
                : {};
          // Normalize keys to lowercase
          final Map<String, dynamic> openingHours = {};
          rawHours.forEach((key, value) {
            if (value is Map) {
              openingHours[key.toString().toLowerCase()] =
                  Map<String, dynamic>.from(value);
            }
          });

          final bool isOpen = _checkIfOpen(openingHours);

          return Column(
            children: [
              ImageSlider(
                imageUrls: gallery,
                onBack: widget.onBack,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: DetailsPart(
                  collegeName: name,
                  location: location,
                  phoneNumber: phoneNumber,  // ← pass the correct phone
                  website: website,          // ← pass the correct website
                  isOpen: isOpen,
                  description: description,
                  openingHours: openingHours,
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }

  bool _checkIfOpen(Map<String, dynamic> openingHours) {
    if (openingHours.isEmpty) return false;

    final now = DateTime.now();
    final String todayKey = _weekdayToKey(now.weekday);

    if (!openingHours.containsKey(todayKey)) return false;
    final dynamic dayMap = openingHours[todayKey];
    if (dayMap == null || dayMap is! Map) return false;

    final String? openStr  = (dayMap['open'] as String?)?.trim();
    final String? closeStr = (dayMap['close'] as String?)?.trim();

    if (openStr == null || openStr.isEmpty) return false;
    if (closeStr == null || closeStr.isEmpty) return false;

    final openParts  = openStr.split(':').map((s) => int.tryParse(s) ?? -1).toList();
    final closeParts = closeStr.split(':').map((s) => int.tryParse(s) ?? -1).toList();
    if (openParts.length != 2 || closeParts.length != 2) return false;
    if (openParts.any((x) => x < 0) || closeParts.any((x) => x < 0)) return false;

    final openTime = DateTime(now.year, now.month, now.day, openParts[0], openParts[1]);
    final closeTime= DateTime(now.year, now.month, now.day, closeParts[0], closeParts[1]);

    return now.isAfter(openTime) && now.isBefore(closeTime);
  }

  String _weekdayToKey(int weekday) {
    switch (weekday) {
      case DateTime.monday:    return 'monday';
      case DateTime.tuesday:   return 'tuesday';
      case DateTime.wednesday: return 'wednesday';
      case DateTime.thursday:  return 'thursday';
      case DateTime.friday:    return 'friday';
      case DateTime.saturday:  return 'saturday';
      case DateTime.sunday:    return 'sunday';
      default: return '';
    }
  }
}
