import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as loc;

class LocationService {
  loc.Location location = loc.Location();

  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final geocoding.Placemark place = placemarks.first;
        return "${place.locality}, ${place.country}";
      }
      return null;
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  Future<loc.LocationData?> getLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData locationData;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return null;
      }
    }

    // Check for location permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        print('Location permissions are denied.');
        return null;
      }
    }

    // Get location data
    try {
      locationData = await location.getLocation();
      print('Location: ${locationData.latitude}, ${locationData.longitude}');
      return locationData;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
}
