import 'package:flutter/material.dart';
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

  final List<Widget> _pages = [
    HomeBody(), // Index 0: Explore
    NavigationPage(), // Index 1: Navigation
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.30;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: CustomAppBar(),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
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
        }, // Go to NavigationPage
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
