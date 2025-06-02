import 'package:flutter/material.dart';
import 'package:smart_guide/Screens/college_info_screen.dart';
import 'package:smart_guide/Screens/settings_screen.dart';
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

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.30;

    return Scaffold(
      backgroundColor: Colors.white,

      // Only show custom app bar on Home tab (index 0)
      appBar: (_currentIndex == 0)
          ? PreferredSize(
              preferredSize: Size.fromHeight(appBarHeight),
              child: CustomAppBar(),
            )
          : null,

      body: _buildCurrentPage(),
      resizeToAvoidBottomInset: false,

      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            if (_currentIndex == 0) {
              // On Home tab with no campus selected => show dialog
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
            } else {
              // If on another tab, push MapWithBottomSheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapWithBottomSheet(),
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

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 1:
        return MapWithBottomSheet();
      case 2:
        return SettingsScreen();
      case 0:
      default:
        return HomeBody(
          onNavigateToCollege: (campusId) {
            // Push CollegeInfoScreen as a new route:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CollegeInfoScreen(
                  campusId: campusId,
                  onBack: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
    }
  }
}
