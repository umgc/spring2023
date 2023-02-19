import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virotour/src/settings/settings_view.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:virotour/src/tour/tour_details_view.dart';

class TourListView extends StatelessWidget {
  static Future<List<Tour>> fetchData() async {
    // TODO: Implement fetching the tour data from an API endpoint
    /*
    final response = await http.get(Uri.parse('https://example.com/tours'));
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData['data'];
    } else {
      throw Exception("failed to load tour data!");
    }

    return data
        .map((tour) => Tour(
        id: tour['id'].toString(),
        tourName: tour['tour_name'].toString(),
        description: tour['description'].toString()))
        .toList();

     */
    final response = [{'data': {"tours":[{"tour_name": "example tour 1", "description": "This is an example tour", "id": 1}, {"tour_name": "example tour 2", "description": "This is another example tour", "id": 2}]}}];

    final data = response[0]['data']!['tours'] as List<dynamic>;

    return data.map((tour) => Tour(
        id: tour['id'].toString(),
        tourName: tour['tour_name'].toString(),
        description: tour['description'].toString()))
        .toList();
  }

  static final Future<List<Tour>> tourData = fetchData();

  const TourListView({
    Key? key,
    required this.items,
  }) : super(key: key);

  static const routeName = '/';

  final List<Tour> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tours'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: FutureBuilder<List<Tour>>(
        future: tourData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data!;
            return ListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              restorationId: 'tourListView',
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];

                return ListTile(
                  // Show the tour name and description
                  title: Text(item.tourName),
                  subtitle: Text(item.description),
                  leading: const CircleAvatar(
                    foregroundImage:
                    AssetImage('assets/images/virotour_logo.png'),
                  ),
                  onTap: () {
                    // TODO: Call the API to get the tour details and navigate
                    // to the details page.
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
