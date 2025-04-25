import 'package:flutter/material.dart';
import 'package:smart_guide/Screens/college_info_screen.dart.dart';
import 'package:smart_guide/Screens/destination.dart';
import 'package:smart_guide/Screens/profile.dart';
import 'package:smart_guide/components/custom_app_bar.dart';
import 'package:smart_guide/Screens/home_body.dart';
import 'package:smart_guide/components/dialog.dart';
import 'package:smart_guide/components/draggable_scrollable_sheet.dart';
import 'package:smart_guide/components/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _pageRoutes = [
    'home',
    'navigate',
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
          _onTabSelected(3); // switch to collegeInfo
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
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.black,
        // elevation: 0,
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

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MapWithBottomSheet(),
          //   ),
          // );
        },
        shape: const CircleBorder(),
        child: Icon(Icons.navigation_rounded, color: Colors.grey[200]),
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
