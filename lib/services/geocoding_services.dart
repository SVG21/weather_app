import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/constant/api_constants.dart';

/// A Provider that provides an instance of the GeocodingService.
final geocodingServiceProvider = Provider((ref) => GeocodingService());

/// A service that provides geocoding functionality.
class GeocodingService {
  /// Converts a city name to coordinates (latitude and longitude).
  Future<(double, double, String)?> forwardGeocode(String name) async {
    final uri = Uri.parse(
      '$openMeteOGeocodeBase/search?name=${Uri.encodeComponent(name)}&count=1',
    );

    final response = await http.get(uri);

    final data = jsonDecode(response.body);

    if (data['results']?.isNotEmpty ?? false) {
      final result = data['results'][0];
      final lat = (result['latitude'] as num).toDouble();
      final lon = (result['longitude'] as num).toDouble();
      final cityName = result['name'].toString();

      return (lat, lon, cityName);
    }

    return null;
  }
}
