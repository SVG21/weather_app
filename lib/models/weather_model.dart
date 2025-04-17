/// Represents the current weather data.
class CurrentWeatherData {
  final double? temperature;
  final double? rainfall;
  final double? uvIndex;
  final double? airQuality;
  final double? pollenCount;
  final bool isDay;

  CurrentWeatherData({
    required this.temperature,
    required this.rainfall,
    required this.uvIndex,
    required this.airQuality,
    required this.pollenCount,
    required this.isDay,
  });
}

/// Represents the forecast data.
class ForecastData {
  final List<double?> temperatures;
  final List<double?> windSpeeds;
  final List<double?> rainfall;
  final List<double?> cloudCover;
  final List<int> isDay;

  ForecastData({
    required this.temperatures,
    required this.windSpeeds,
    required this.rainfall,
    required this.cloudCover,
    required this.isDay,
  });
}
