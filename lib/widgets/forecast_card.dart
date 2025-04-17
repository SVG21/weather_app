import 'package:flutter/material.dart';

/// A widget that displays the forecast for a single day.
class ForecastCard extends StatelessWidget {
  final String dayName;
  final bool isDay;
  final double? temperature;
  final double? windSpeed;
  final double? rainfall;
  final double? cloudCover;

  const ForecastCard({
    super.key,
    required this.dayName,
    required this.isDay,
    this.temperature,
    this.windSpeed,
    this.rainfall,
    this.cloudCover,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: day/night icon, day name, and label
              Row(
                children: [
                  Icon(
                    isDay ? Icons.wb_sunny : Icons.nightlight_round,
                    color: isDay ? Colors.orange : Colors.indigo,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    dayName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '24 hr Forecast',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),

              // Temperature: Thermostat icon
              if (temperature != null)
                Row(
                  children: [
                    const Icon(Icons.thermostat, color: Colors.red),
                    const SizedBox(width: 6),
                    Text('$temperature °C'),
                  ],
                ),
              const SizedBox(height: 6),

              // Wind Speed: Air icon
              if (windSpeed != null)
                Row(
                  children: [
                    const Icon(Icons.air, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text('$windSpeed km/h'),
                  ],
                ),
              const SizedBox(height: 6),

              // Rainfall: Water drop icon
              if (rainfall != null)
                Row(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.lightBlue),
                    const SizedBox(width: 6),
                    Text('$rainfall mm rainfall'),
                  ],
                ),
              const SizedBox(height: 6),

              // Cloud Cover: Cloud icon
              if (cloudCover != null)
                Row(
                  children: [
                    const Icon(Icons.cloud, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text('$cloudCover% cloud cover'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
