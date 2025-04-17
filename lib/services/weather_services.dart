import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/constant/api_constants.dart';
import 'package:weather_app/models/weather_model.dart';


/// A service that provides weather data.
class WeatherService {
  /// Fetches the current weather data for given coordinates.
  Future<CurrentWeatherData> fetchCurrentWeather(double lat, double lon) async {
    final url = Uri.parse(
      '$openMeteOBase?latitude=$lat&longitude=$lon'
          '&current=temperature_2m,precipitation,uv_index,is_day'
          '&timezone=auto',
    );

    debugPrint('[Weather] Current weather URL: $url');

    final response = await http.get(url);
    debugPrint('[Weather] Current weather response: ${response.body}');

    final json = jsonDecode(response.body);
    final current = json['current'];

    final airData = await fetchAirQualityAndPollen(lat, lon);

    debugPrint('[Weather] Current temperature: ${current['temperature_2m']}');
    debugPrint('[Weather] UV Index: ${current['uv_index']}');
    debugPrint('[Weather] Air Quality (pm10): ${airData?.$1}');
    debugPrint('[Weather] Pollen Count: ${airData?.$2}');

    return CurrentWeatherData(
      temperature: (current['temperature_2m'] as num?)?.toDouble(),
      rainfall: (current['precipitation'] as num?)?.toDouble(),
      uvIndex: (current['uv_index'] as num?)?.toDouble(),
      isDay: current['is_day'] == 1,
      airQuality: airData?.$1,
      pollenCount: airData?.$2,
    );
  }

  /// Fetches air quality and pollen data for given coordinates.
  Future<(double? pm10, double? pollen)?> fetchAirQualityAndPollen(
      double lat, double lon) async {
    try {
      final airUrl = Uri.parse(
        '$openMeteOAirQualityBase?latitude=$lat&longitude=$lon'
            '&hourly=pm10,grass_pollen&timezone=auto',
      );

      debugPrint('[Air] URL: $airUrl');

      final airResponse = await http.get(airUrl);
      debugPrint('[Air] Response: ${airResponse.body}');

      final airJson = jsonDecode(airResponse.body);

      final List<dynamic> airTimes = airJson['hourly']['time'];
      final List<dynamic> pm10 = airJson['hourly']['pm10'];
      final List<dynamic> pollen = airJson['hourly']['grass_pollen'];
      final now = DateTime.now();
      final roundedNow = DateTime(now.year, now.month, now.day, now.hour);
      final roundedIso = roundedNow.toIso8601String().substring(0, 16);

      debugPrint('Matching timestamp: $roundedIso');
      final index =
      airTimes.indexWhere((t) => (t as String).startsWith(roundedIso));
      if (index == -1) {
        debugPrint('No matching timestamp found for air quality.');
        return (null, null);
      }

      final double? airQuality = (pm10[index] as num?)?.toDouble();
      final double? pollenCount = (pollen[index] as num?)?.toDouble();

      return (airQuality, pollenCount);
    } catch (e) {
      debugPrint('[Air/Pollen Error] $e');
      return (null, null);
    }
  }

  /// Fetches the forecast data for given coordinates.
  Future<ForecastData> fetchForecast(double lat, double lon) async {
    final url = Uri.parse(
      '$openMeteOBase?latitude=$lat&longitude=$lon'
          '&daily=temperature_2m_max,precipitation_sum,windspeed_10m_max,cloudcover_mean'
          '&timezone=auto',
    );

    debugPrint('🌍 [Forecast] URL: $url');

    final response = await http.get(url);
    debugPrint('[Forecast] Response: ${response.body}');

    final json = jsonDecode(response.body);
    final daily = json['daily'];
    if (daily == null) throw Exception("Forecast data unavailable.");
    return ForecastData(
      temperatures: List<double?>.from(daily['temperature_2m_max'] ?? []),
      windSpeeds: List<double?>.from(daily['windspeed_10m_max'] ?? []),
      rainfall: List<double?>.from(daily['precipitation_sum'] ?? []),
      cloudCover: (daily['cloudcover_mean'] as List)
          .map((e) => (e as num?)?.toDouble())
          .toList(),
      isDay: List<int>.filled(
        (daily['temperature_2m_max'] ?? []).length,
        1,
      ),
    );
  }
}
