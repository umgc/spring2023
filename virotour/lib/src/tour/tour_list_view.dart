import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virotour/src/settings/settings_view.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:virotour/src/tour/tour_details_view.dart';
import 'package:virotour/src/tour/tour_edit_view.dart';
import 'package:virotour/src/hamburger.dart';

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
        await http.get(Uri.parse('http://192.168.50.43:8081/api/tours'),
          headers: {'Content-Type': 'application/json'},
        );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final dataLength = data["tours"].length;

      // If response is empty, create text that no tours are found
      if (dataLength == 0) {
        return [
          Tour(
            id: '0',
            tourName: 'No tours found!',
            description: '',
          )
        ];
      }

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
        leading: Hamburger(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const maxWidth = 800.0;
          final isNarrow = constraints.maxWidth < maxWidth;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _tourData = fetchData();
              });
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isNarrow ? constraints.maxWidth : maxWidth,
              ),
              child: FutureBuilder<List<Tour>>(
                future: _tourData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final items = snapshot.data!;
                    if (items.length == 1 && items.first.id == '0') {
                      return Center(
                        child: ListView(
                          restorationId: 'tourListView',
                          children: [
                            ListTile(
                              title: Text(
                                items.first.tourName,
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      restorationId: 'tourListView',
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = items[index];
                        String toTitleCase(String str) {
                          if (str.isEmpty) return str;
                          return str.substring(0, 1).toUpperCase() +
                              str.substring(1);
                        }

                        return ListTile(
                          title: Text(toTitleCase(item.tourName)),
                          subtitle: Text(toTitleCase(item.description)),
                          leading: const CircleAvatar(
                            foregroundImage:
                                AssetImage('assets/images/virotour_logo.png'),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TourEditView(
                                    tour: item,
                                  ),
                                ),
                              );
                            },
                            child: const Icon(Icons.edit),
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
        },
      ),
    );
  }
}
