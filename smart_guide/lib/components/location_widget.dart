import 'package:flutter/material.dart';
import "package:smart_guide/Services/location_service.dart";

class LocationWidget extends StatefulWidget {
  @override
  LocationWidgetState createState() => LocationWidgetState();
}

class LocationWidgetState extends State<LocationWidget> {
  String location = "Fetching location...";
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    final locationData = await _locationService.getLocation();
    if (locationData != null) {
      String? address = await _locationService.getAddressFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );
      setState(() {
        location = address ?? "Location not found";
      });
    } else {
      setState(() {
        location = "Unable to fetch location.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, color: Color.fromARGB(255, 251, 3, 3)),
        SizedBox(width: 8),
        Text(
          location,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
