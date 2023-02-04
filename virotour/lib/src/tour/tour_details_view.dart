import 'package:flutter/material.dart';

/// Displays detailed information about a Tour.
class TourDetailsView extends StatelessWidget {
  const TourDetailsView({super.key});

  static const routeName = '/tour';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour Details'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
