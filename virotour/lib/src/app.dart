import 'package:flutter/material.dart';
import 'package:virotour/src/tour/tour_list_view.dart';

import './tour/tour_list_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebViewX Example App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TourListView(),
    );
  }
}
