import 'package:flutter/material.dart';

/// A widget that displays an error message.
class ErrorFallback extends StatelessWidget {
  final String message;

  const ErrorFallback({super.key, this.message = "Something went wrong. Please try again."});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
