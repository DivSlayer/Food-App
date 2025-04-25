
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  LocationData? _currentLocation;

  Future<LocationData?> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if the location services are enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      // Request the user to enable the location services
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return null; // Location services are not enabled
      }
    }

    // Check for location permissions
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      // If permissions are denied, request for permission
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null; // Permission denied
      }
    }

    // Get the current location
    _currentLocation = await _location.getLocation();
    return _currentLocation;
  }
}