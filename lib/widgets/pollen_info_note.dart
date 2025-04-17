import 'package:flutter/material.dart';

/// A small UI widget that shows an informational note about pollen count visibility
class PollenInfoNote extends StatelessWidget {
  const PollenInfoNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline, size: 20), // Info icon
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Note: The pollen count will only be displayed for Europe.',
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
