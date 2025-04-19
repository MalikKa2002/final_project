import 'package:flutter/material.dart';
import 'package:smart_guide/Screens/college_info_screen.dart.dart';
import 'package:smart_guide/Screens/profile.dart';
import 'package:smart_guide/components/custom_app_bar.dart';
import 'package:smart_guide/Screens/home_body.dart';
import 'package:smart_guide/components/dialog.dart';
import 'package:smart_guide/components/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _pageRoutes = [
    'home',
    'profile',
    'collegeInfo',
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildCurrentPage() {
    switch (_pageRoutes[_currentIndex]) {
      case 'collegeInfo':
        return CollegeInfoScreen();
      case 'profile':
        return ProfilePage();
      case 'home':
      default:
        return HomeBody(onNavigateToCollege: () {
          _onTabSelected(2); // switch to collegeInfo
        });
    } // This one already has CustomAppBar
// This one already has CustomAppBar
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.30;

    return Scaffold(
      backgroundColor: Colors.white,
      // Only show app bar for home; profile has its own app bar if needed
      appBar: _currentIndex == 0
          ? PreferredSize(
              preferredSize: Size.fromHeight(appBarHeight),
              child: CustomAppBar(),
            )
          : null,
      body: _buildCurrentPage(),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black, // Golden border (great contrast with green)
            width: 2.5,
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent, // Make FAB itself transparent
          elevation: 0, // Remove elevation for flat look
          splashColor: Colors.transparent, // Remove ripple effect
          highlightElevation: 0,
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => CustomMessageDialog(
                icon: Icons.location_city_outlined,
                title: "To Start!",
                subtitle: "Are you ready to start ?",
                description: "Please choose a building to start navigation!",
                onOkPressed: () => Navigator.of(context).pop(),
              ),
            );
          },
          shape: const CircleBorder(),
          child: SizedBox(
            height: 40,
            width: 40,
            child: Image.asset("assets/AR.png"),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
