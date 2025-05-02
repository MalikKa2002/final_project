import 'package:flutter/material.dart';
import 'package:smart_guide/Buttons/quick_button.dart';
import 'package:smart_guide/Screens/destination.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapWithBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(children: [
        Destination(),
        DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.1,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // The scrollable content
                  SizedBox(height: 20),
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        controller: scrollController,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: local.whereToGo,
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              QuickButton(
                                  icon: Icons.food_bank, label: "Cafitaria"),
                              QuickButton(
                                  icon: Icons.bathroom, label: "Bathroom"),
                              QuickButton(icon: Icons.add, label: "New"),
                            ],
                          ),
                          // Add more items here
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ]),
    );
  }
}
