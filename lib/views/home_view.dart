import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/controllers/location_controller.dart';
import 'package:weather_app/widgets/error_fallback.dart';
import 'package:weather_app/widgets/location_search_bar.dart';
import 'package:weather_app/widgets/pollen_info_note.dart';
import 'package:weather_app/widgets/weather_list.dart';


/// The main view of the app, displaying the current weather and a list of saved locations.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationControllerProvider);
    final additionalLocations = ref.watch(locationStateNotifierProvider);
    return locationAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const Scaffold(
        body: Center(child: ErrorFallback()),
      ),
      data: (location) => Scaffold(
        appBar: AppBar(title: const Text('Weather Now')),
        body: Column(
          children: [
            // A search bar for adding new locations.
            LocationSearchBar(),
            // A note about pollen information.
            PollenInfoNote(),
            // A list of weather cards, displaying the current weather for the user's location and saved locations.
            WeatherList(
              location: location,
              additionalLocations: additionalLocations,
            ),
          ],
        ),
      ),
    );
  }
}
