import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const CustomBottomNavBar(
      {required this.onTabSelected, required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      currentIndex: currentIndex, // Provide currentIndex for highlighting
      onTap: (index) {
        onTabSelected(index);
      },
      // <- Handle tab taps
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: local.explore,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.navigation_rounded),
          label: local.navigation,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: local.profile,
        ),
      ],
    );
  }
}
