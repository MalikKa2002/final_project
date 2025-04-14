import 'package:flutter/material.dart';
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
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildCurrentPage() {
    switch (_pageRoutes[_currentIndex]) {
      case 'profile':
        return ProfilePage();
      case 'home':
      default:
        return HomeBody(); // This one already has CustomAppBar
// This one already has CustomAppBar
    }
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
        shape: CircleBorder(),
        child: SizedBox(
          height: 40,
          width: 40,
          child: Image.asset("assets/AR.png"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
