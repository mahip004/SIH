import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationHelper {
  static const String _latKey = "latitude";
  static const String _lonKey = "longitude";

  // Get saved location if it exists
  static Future<Position?> getSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble(_latKey);
    double? lon = prefs.getDouble(_lonKey);
    if (lat != null && lon != null) {
      return Position(
        latitude: lat,
        longitude: lon,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        headingAccuracy: 0,
        altitudeAccuracy: 0,
      );
    }
    return null;
  }

  // Ask for permission and fetch current location
  static Future<Position?> askLocationPermissionAndFetch() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Save location for future use
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, position.latitude);
    await prefs.setDouble(_lonKey, position.longitude);

    return position;
  }
}
