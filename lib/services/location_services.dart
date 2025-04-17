import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that handles saving and loading locations to local storage using SharedPreferences.
class LocationStorageService {
  static const _key = 'saved_locations';

  /// Saves a list of locations to SharedPreferences.
  Future<void> saveLocations(List<(double, double, String)> locations) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = locations
        .map((loc) => jsonEncode({
      'lat': loc.$1,
      'lon': loc.$2,
      'name': loc.$3,
    }))
        .toList();
    await prefs.setStringList(_key, encoded);
  }

  /// Loads a list of locations from SharedPreferences.
  Future<List<(double, double, String)>> loadLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_key) ?? [];
    return encoded.map((str) {
      final map = jsonDecode(str);
      return (
      (map['lat'] as num).toDouble(),
      (map['lon'] as num).toDouble(),
      map['name'] as String
      );
    }).toList();
  }

  /// Removes a specific location from the saved locations in SharedPreferences.
  Future<void> removeLocation((double, double, String) location) async {
    final locations = await loadLocations();
    locations.removeWhere((loc) =>
    loc.$1 == location.$1 &&
        loc.$2 == location.$2 &&
        loc.$3 == location.$3);
    await saveLocations(locations);
  }
}
