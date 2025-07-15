import 'package:flutter/material.dart';
// import 'package:smart_guide/Buttons/quick_button.dart';
import 'package:smart_guide/Screens/destination.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_guide/components/place_selectionList.dart';

class MapWithBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> places = [
    {'label': 'Cafeteria', 'icon': Icons.food_bank},
    {'label': 'Bathroom', 'icon': Icons.bathroom},
    {'label': 'New', 'icon': Icons.add},
  ];

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
                          PlaceSelectionList(
                            places: places,
                            onSelected: (selectedLabel) {
                              print("User selected: $selectedLabel");
                              // You can navigate, filter, or update UI based on the selection
                            },
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
