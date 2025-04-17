import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/controllers/location_controller.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:weather_app/views/forecast_view.dart';
import 'package:weather_app/widgets/error_fallback.dart';
import 'package:weather_app/widgets/weather_card.dart';

/// Displays a scrollable list of weather cards for the user's current and saved locations.
class WeatherList extends ConsumerWidget {
  final ({double lat, double lon, String name}) location;
  final List<(double, double, String)> additionalLocations;

  const WeatherList({
    super.key,
    required this.location,
    required this.additionalLocations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allWeatherLoaded = additionalLocations.every((loc) {
      final weather = ref.watch(currentWeatherProvider((loc.$1, loc.$2)));
      return weather.asData != null;
    });

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(locationControllerProvider);
          for (var loc in additionalLocations) {
            ref.invalidate(currentWeatherProvider((loc.$1, loc.$2)));
          }
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildWeatherCard(
                context, ref, location.lat, location.lon, location.name),
            ...additionalLocations.map(
                  (loc) => Dismissible(
                key: Key('${loc.$1}-${loc.$2}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  ref
                      .read(locationStateNotifierProvider.notifier)
                      .removeLocation(loc);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${loc.$3} removed')),
                  );
                },
                child: _buildWeatherCard(context, ref, loc.$1, loc.$2, loc.$3),
              ),
            ),
            if (!allWeatherLoaded)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds a single weather card (used for both current and saved locations)
  Widget _buildWeatherCard(BuildContext context, WidgetRef ref, double lat,
      double lon, String label) {
    final weatherAsync = ref.watch(currentWeatherProvider((lat, lon)));

    return weatherAsync.when(
      data: (data) => WeatherCard(
        weather: data,
        locationTitle: label,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ForecastView(lat: lat, lon: lon)),
          );
        },
      ),
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const ErrorFallback(message: "Error loading weather"),
    );
  }
}
