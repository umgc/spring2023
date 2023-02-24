import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virotour/src/settings/settings_view.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:virotour/src/tour/tour_details_view.dart';

class TourListView extends StatefulWidget {
  const TourListView({
    super.key,
    required this.items,
  });

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
    final response =
        await http.get(Uri.parse('http://192.168.1.217:5000/api/tours'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final tours = data['tours'] as List<dynamic>;

      return tours
          .map((tour) => Tour(
                id: tour['id'].toString(),
                tourName: tour['name'].toString(),
                description: tour['description'].toString(),
              ))
          .toList();
    } else {
      throw Exception("Failed to load tour data!");
    }
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
