import 'package:flutter/material.dart';
import 'package:smart_guide/components/custom_app_bar.dart';
import 'package:smart_guide/Screens/home_body.dart';
import 'package:smart_guide/components/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.30; // 25% of screen height

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight), // Dynamic height
        child: CustomAppBar(),
      ),
      // body: HomeBody(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(
                      child: HomeBody(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('AR Button Pressed!');
        },
        shape: CircleBorder(), // Ensure the FAB is circular
        child: SizedBox(
          height: 40,
          width: 40,
          child: Image.asset("assets/AR.png"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
