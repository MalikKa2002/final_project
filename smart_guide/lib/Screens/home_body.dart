// home_body.dart
import 'package:flutter/material.dart';
import 'package:smart_guide/components/university_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ← NEW
import '../components/add_campus_card.dart';

class HomeBody extends StatefulWidget {
  final VoidCallback? onNavigateToCollege;

  HomeBody({this.onNavigateToCollege});
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    local.universityAndCollege,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AddCampusCard(),
                ],
              ),
              SizedBox(height: 20),

              // ← FIRESTORE STREAM
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('campuses') // ← your collection name
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("No campuses found.");
                  }

                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data()! as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: UniversityCard(
                          imagePath: data['cover_image'] as String,
                          title: data['college_name'] as String,
                          distance:
                              '', // you can fetch & show these too if stored
                          time: '',
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
