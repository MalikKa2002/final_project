import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  String searchResult = "";
  TextEditingController searchController = TextEditingController();

  // List of available results
  List<String> allItems = [
    'Building A',
    'Building B',
    'Library',
    'Cafeteria',
    'Gym',
    'Student Center',
    'Parking Lot',
    'Admin Office',
  ];

  void _showResult(String query, AppLocalizations local) {
    setState(() {
      if (allItems.any((item) => item.toLowerCase() == query.toLowerCase())) {
        searchResult = "Result found: $query";
      } else {
        searchResult = local.noResult;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54
                    ..withAlpha((0.2 * 255).toInt()), // Shadow color
                  spreadRadius: 1, // How much the shadow spreads
                  blurRadius: 5, // How blurry the shadow is
                  offset: Offset(0, 2), // Shadow position (x, y)
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (query) => _showResult(query, local),
                    decoration: InputDecoration(
                      hintText: local.search,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Icon(Icons.mic, color: Colors.grey),
              ],
            ),
          ),
          // SizedBox(height: 20),
          Text(
            searchResult,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
