import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virotour/src/settings/settings_view.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:virotour/src/tour/tour_details_view.dart';

class TourListView extends StatefulWidget {
  const TourListView({
    Key? key,
    required this.items,
  }) : super(key: key);

  static const routeName = '/';

  final List<Tour> items;

  @override
  _TourListViewState createState() => _TourListViewState();
}

class _TourListViewState extends State<TourListView> {
  late Future<List<Tour>> _tourData;

  @override
  void initState() {
    super.initState();
    _tourData = fetchData();
  }

  static Future<List<Tour>> fetchData() async {
    // TODO: Implement fetching the tour data from an API endpoint
    // final response = await http.get(Uri.parse('https://virotour.com/tours/endpoint'));
    final response = [
      {
        'data': {
          "tours": [
            {
              "tour_name": "example tour 1",
              "description": "This is an example tour",
              "id": 1
            },
            {
              "tour_name": "example tour 2",
              "description": "This is another example tour",
              "id": 2
            }
          ]
        }
      }
    ];

    // if (response.statusCode == 200) {
    //   final responseData = jsonDecode(response.body);
    final data = response[0]['data']!['tours'] as List<dynamic>;

    return data
        .map((tour) => Tour(
              id: tour['id'].toString(),
              tourName: tour['tour_name'].toString(),
              description: tour['description'].toString(),
            ))
        .toList();
    // } else {
    //   throw Exception("Failed to load tour data!");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tours'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _tourData = fetchData();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _tourData = fetchData();
          });
        },
        child: FutureBuilder<List<Tour>>(
          future: _tourData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data!;
              return ListView.builder(
                restorationId: 'tourListView',
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];

                  return ListTile(
                    title: Text(item.tourName),
                    subtitle: Text(item.description),
                    leading: const CircleAvatar(
                      foregroundImage:
                          AssetImage('assets/images/virotour_logo.png'),
                    ),
                    onTap: () {
                      Navigator.restorablePushNamed(
                        context,
                        TourDetailsView.routeName,
                      );
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
      ),
    );
  }
}
