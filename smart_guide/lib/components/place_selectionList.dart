import 'package:flutter/material.dart';

class PlaceSelectionList extends StatelessWidget {
  final List<Map<String, dynamic>> places;
  final void Function(String label)? onSelected;

  const PlaceSelectionList({
    super.key,
    required this.places,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return ListTile(
          leading: Icon(place['icon']),
          title: Text(place['label']),
          onTap: () {
            if (onSelected != null) {
              onSelected!(place['label']);
            }
          },
        );
      },
    );
  }
}
