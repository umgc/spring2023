import 'package:flutter/material.dart';

/// Displays detailed information about a Tour.
class TourDetailsView extends StatefulWidget {
  const TourDetailsView({super.key});
  static const routeName = '/tour';

  @override
  State<TourDetailsView> createState() => _TourDetailsViewState();
}

class _TourDetailsViewState extends State<TourDetailsView> {
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
