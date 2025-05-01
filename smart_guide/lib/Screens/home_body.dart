// home_body.dart
import 'package:flutter/material.dart';
import 'package:smart_guide/components/university_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../components/add_campus_card.dart';

class HomeBody extends StatefulWidget {
  final VoidCallback? onNavigateToCollege;

  HomeBody({this.onNavigateToCollege});
  @override
  createState() => _HomeBodyState();
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
              // Universities & Colleges Section
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
              Column(
                children: [
                  GestureDetector(
                    onTap: widget.onNavigateToCollege,
                    child: UniversityCard(
                      imagePath: 'assets/azrieli_college.png',
                      title: 'Azrieli College',
                      distance: '2.8km away',
                      time: '32 mins',
                    ),
                  ),
                  SizedBox(height: 20),
                  UniversityCard(
                    imagePath: 'assets/hebrew_university.png',
                    title: 'Hebrew University',
                    distance: '2.8km away',
                    time: '32 mins',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
