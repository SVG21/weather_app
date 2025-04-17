import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

/// A Provider that provides an instance of the WeatherService.
final weatherServiceProvider = Provider((ref) => WeatherService());

/// A FutureProvider.family that fetches the current weather data for given coordinates.
/// It uses the WeatherService to fetch the data.
final currentWeatherProvider =
FutureProvider.family<CurrentWeatherData, (double, double)>(
        (ref, coordinates) {
      return ref
          .read(weatherServiceProvider)
          .fetchCurrentWeather(coordinates.$1, coordinates.$2);
    });

/// A FutureProvider.family that fetches the forecast data for given coordinates.
/// It uses the WeatherService to fetch the data.
final forecastProvider =
FutureProvider.family<ForecastData, (double, double)>((ref, coordinates) {
  return ref
      .read(weatherServiceProvider)
      .fetchForecast(coordinates.$1, coordinates.$2);
});
