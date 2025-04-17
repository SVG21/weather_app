import 'package:flutter/material.dart';
import 'package:weather_app/widgets/forecast_list.dart';

/// A view that displays the 7-day forecast for a given location.
class ForecastView extends StatelessWidget {
  final double lat;
  final double lon;

  const ForecastView({super.key, required this.lat, required this.lon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7-Day Forecast')),
      // Inject lat/lon to ForecastList widget
      body: ForecastList(lat: lat, lon: lon),
    );
  }
}
