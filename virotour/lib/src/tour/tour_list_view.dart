import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virotour/src/settings/settings_view.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:virotour/src/tour/tour_details_view.dart';
import 'package:virotour/src/tour/tour_edit_view.dart';

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
        actions: [                  //wheel_menu action start
          PopupMenuButton<int>(
            color: Colors.lightBlue[600],
            icon: const Icon(Icons.settings),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.sunny,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 15.0),
                      Text(
                        'Glow Effect',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),),
              PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(
                        Icons
                            .voicemail_outlined, //this icon is used because VR view icon is missing in material apps
                        color: Colors.white70,
                      ),
                      SizedBox(width: 15.0),
                      Text(
                        'VR View',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),),
            ],
          )

        ],                //wheel_menu action end



                    //the following is the initial wheel_menu actions code
        // actions [
        //   IconButton(
        //     icon: const Icon(Icons.settings),
        //     onPressed: () {
        //       Navigator.restorablePushNamed(context, SettingsView.routeName);
        //     },
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _tourData = fetchData();
          });
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            const maxWidth = 800.0;
            final isNarrow = constraints.maxWidth < maxWidth;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isNarrow ? constraints.maxWidth : maxWidth,
                ),
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
      ),
    );
  }
  //wheel_menu onSelected destinations
  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.restorablePushNamed(
          context, SettingsView.routeName,); //Place holder for 'Glow Effect'
        break;
      case 1:
        Navigator.restorablePushNamed(
          context, SettingsView.routeName,); //Place holder for 'VR View'
    }
  }

}

