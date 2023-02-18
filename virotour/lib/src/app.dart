import 'package:flutter/material.dart';
import 'package:virotour/src/tour/tour_list_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViroTour',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TourListView(),
    );
  }
}
