import 'package:flutter/material.dart';
import 'package:smart_guide/Screens/college_info_screen.dart';
import 'package:smart_guide/Screens/profile.dart';
import 'package:smart_guide/components/custom_app_bar.dart';
import 'package:smart_guide/Screens/home_body.dart';
import 'package:smart_guide/components/dialog.dart';
import 'package:smart_guide/components/draggable_scrollable_sheet.dart';
import 'package:smart_guide/components/nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _showCollegeInfo = false;

  final List<String> _pageRoutes = [
    'home', // 0
    'navigate', // 1
    'profile', // 2
    'collegeInfo', // 3
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
      _showCollegeInfo = false; // back to normal tabs
    });
  }

  Widget _buildCurrentPage() {
    if (_showCollegeInfo) {
      return CollegeInfoScreen();
    }

    switch (_currentIndex) {
      case 1:
        return MapWithBottomSheet();
      case 2:
        return ProfilePage();
      case 0:
      default:
        return HomeBody(
          onNavigateToCollege: () {
            setState(() {
              _showCollegeInfo = true;
            });
          }, // Go to collegeInfo
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.30;
    return Scaffold(
      backgroundColor: Colors.white,
      // Only show app bar for home; profile has its own app bar if needed
      appBar: _currentIndex == 0 && _showCollegeInfo == false
          ? PreferredSize(
              preferredSize: Size.fromHeight(appBarHeight),
              child: CustomAppBar(),
            )
          : null,
      body: _buildCurrentPage(),
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        width: 60, // Custom width
        height: 60, // Custom height
        child: FloatingActionButton(
          // backgroundColor: Colors.transparent,
          backgroundColor: Colors.black,
          // elevation: 0,
          onPressed: () {
            if (_showCollegeInfo) {
              // If a building is selected, go to MapWithBottomSheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapWithBottomSheet(),
                ),
              );
            } else {
              // If no building selected, show dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => CustomMessageDialog(
                  icon: Icons.location_city_outlined,
                  title: local.tostart,
                  subtitle: local.areYouReady,
                  description: local.pleaseChoose,
                  onOkPressed: () => Navigator.of(context).pop(),
                ),
              );
            }
          },
          shape: const CircleBorder(),
          child: Icon(Icons.navigation_rounded, color: Colors.grey[200]),
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
