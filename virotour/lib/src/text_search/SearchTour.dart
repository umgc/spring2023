import 'package:flutter/material.dart';
import 'package:virotour/src/text_search/search_screen.dart';

class SearchTour extends StatelessWidget {
  const SearchTour({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const viroTitle = 'Search Tours';
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(viroTitle),
        ),
        body: const SearchScreen(),
      ),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
    );
  }
}
