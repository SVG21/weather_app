import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:weather_app/widgets/error_fallback.dart';
import 'package:weather_app/widgets/forecast_card.dart';


/// A widget that displays a list of forecast cards for the next 7 days.
class ForecastList extends ConsumerWidget {
  final double lat;
  final double lon;

  const ForecastList({super.key, required this.lat, required this.lon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastAsync = ref.watch(forecastProvider((lat, lon)));

    return forecastAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const ErrorFallback(),
      data: (data) {
        final now = DateTime.now();

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(forecastProvider((lat, lon)));
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data.temperatures.length,
            itemBuilder: (context, i) {
              final day = now.add(Duration(days: i));
              final dayName = DateFormat.EEEE().format(day);
              final isDay = data.isDay[i] == 1;

              return ForecastCard(
                dayName: dayName,
                isDay: isDay,
                temperature: data.temperatures[i],
                windSpeed: data.windSpeeds[i],
                rainfall: data.rainfall[i],
                cloudCover: data.cloudCover[i],
              );
            },
          ),
        );
      },
    );
  }
}
