import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/services/geocoding_services.dart';
import 'package:weather_app/services/location_services.dart';

/// A FutureProvider that fetches the user's current location.
/// It returns a record containing the latitude, longitude, and a default name "Your Location".
final locationControllerProvider =
FutureProvider<({double lat, double lon, String name})>((ref) async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Please grant location permission.");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception("Location access permanently denied.");
  }

  final position = await Geolocator.getCurrentPosition();

  return (
  lat: position.latitude,
  lon: position.longitude,
  name: "Your Location"
  );
});

/// A StateNotifierProvider that manages a list of saved locations.
/// It uses the LocationController to handle adding, removing, and loading locations.
final locationStateNotifierProvider =
StateNotifierProvider<LocationController, List<(double, double, String)>>(
      (ref) => LocationController(ref),
);

/// A StateNotifier that manages a list of saved locations.
class LocationController extends StateNotifier<List<(double, double, String)>> {
  final Ref ref;
  final _storage = LocationStorageService();

  LocationController(this.ref) : super([]) {
    _loadSavedLocations();
  }

  /// Loads saved locations from local storage and updates the state.
  Future<void> _loadSavedLocations() async {
    final saved = await _storage.loadLocations();
    state = [...saved];
  }

  /// Adds a new location to the list of saved locations.
  /// It uses the GeocodingService to convert a city name to coordinates.
  Future<bool?> addLocation(String input) async {
    final geocodeService = ref.read(geocodingServiceProvider);
    final result = await geocodeService.forwardGeocode(input);

    if (result == null) return null;

    final exists = state.any((loc) =>
    loc.$1 == result.$1 && loc.$2 == result.$2 && loc.$3 == result.$3);
    if (exists) return false;

    state = [...state, result];
    await _storage.saveLocations(state);
    return true;
  }

  /// Removes a location from the list of saved locations.
  Future<void> removeLocation((double, double, String) loc) async {
    state = [...state]..remove(loc);
    await _storage.removeLocation(loc);
  }
}
