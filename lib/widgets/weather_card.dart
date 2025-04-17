import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';

/// A widget that displays the current weather information for a location.
class WeatherCard extends StatelessWidget {
  final CurrentWeatherData weather;
  final VoidCallback onTap;
  final String locationTitle;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.onTap,
    required this.locationTitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDay = weather.isDay;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row showing time of day icon, location name, and 'Day/Night' label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Day/Night indicator
                        Icon(
                          isDay ? Icons.wb_sunny : Icons.nightlight_round,
                          color: isDay ? Colors.orange : Colors.indigo,
                        ),
                        const SizedBox(width: 8),

                        // Location title (e.g. Kathmandu, Your Location)
                        Text(
                          locationTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Displays whether it's Day or Night
                    Text(
                      isDay ? 'Day' : 'Night',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isDay ? Colors.orange : Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Temperature: Thermostat icon
                if (weather.temperature != null)
                  Row(
                    children: [
                      const Icon(Icons.thermostat, color: Colors.red),
                      const SizedBox(width: 6),
                      Text('${weather.temperature} °C'),
                    ],
                  ),
                const SizedBox(height: 6),

                // Rainfall: Water drop icon
                if (weather.rainfall != null)
                  Row(
                    children: [
                      const Icon(Icons.water_drop, color: Colors.blueAccent),
                      const SizedBox(width: 6),
                      Text('${weather.rainfall} mm rainfall'),
                    ],
                  ),
                const SizedBox(height: 6),

                // UV Index: UV light icon
                if (weather.uvIndex != null)
                  Row(
                    children: [
                      const Icon(Icons.wb_iridescent, color: Colors.purple),
                      const SizedBox(width: 6),
                      Text('UV Index: ${weather.uvIndex}'),
                    ],
                  ),
                const SizedBox(height: 6),

                // Air Quality (PM10): Air icon
                if (weather.airQuality != null)
                  Row(
                    children: [
                      const Icon(Icons.air, color: Colors.teal),
                      const SizedBox(width: 6),
                      Text('Air Quality (PM10): ${weather.airQuality}'),
                    ],
                  ),
                const SizedBox(height: 6),

                // Pollen Count: Grass icon
                if (weather.pollenCount != null)
                  Row(
                    children: [
                      const Icon(Icons.grass, color: Colors.green),
                      const SizedBox(width: 6),
                      Text('Pollen Count: ${weather.pollenCount}'),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
