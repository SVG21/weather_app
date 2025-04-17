import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/controllers/location_controller.dart';

/// A widget that provides a search bar for adding new locations.
class LocationSearchBar extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  LocationSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Add city (e.g. Kathmandu)',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final added = await ref
                  .read(locationStateNotifierProvider.notifier)
                  .addLocation(_controller.text);

              // Show a snack bar to inform the user about the result of the operation.
              if (context.mounted) {
                if (added == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not find that city')),
                  );
                } else if (!added) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location already added')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '${_controller.text} added. Swipe to remove.')),
                  );
                }
              }

              _controller.clear();
            },
          ),
        ),
      ),
    );
  }
}
