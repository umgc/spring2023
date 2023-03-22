import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:webviewx/webviewx.dart';
import 'package:http/http.dart' as http;

import '../helpers/ip_handler.dart';
import '../settings/settings_view.dart';

/// Displays detailed information about a Tour.
class TourDetailsView extends StatefulWidget {
  const TourDetailsView({super.key, required this.tour});
  static const routeName = '/tour';
  final Tour tour;

  // print(widget.tour.id);
  @override
  State<TourDetailsView> createState() => _TourDetailsViewState();
}

class _TourDetailsViewState extends State<TourDetailsView> {
  late WebViewXController webviewController;

  Future<Tour> getTourInfo() async {
    final http.Response response =
        await IPHandler().get('/api/tour/${widget.tour.id}');

    if (response.statusCode == 200) {
      final Tour tour = jsonDecode(response.body) as Tour;
      print('where is $tour');
      return tour;
    } else {
      throw Exception("Failed to load tour data!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final padding = MediaQuery.of(context).padding;
    final safeHeight = height - padding.top - padding.bottom;
    final safeWidth = width - padding.left - padding.right;

    // TODO: Mock returned object from GET /tour/<tour_id>
    const Map<String, dynamic> mockTourInfo = <String, dynamic>{
      "tour_id": "tour_1",
      "start_location": "location_1",
      "locations": {
        "location_1": {
          "url":
              "https://cdn.pannellum.org/2.5/pannellum.htm#panorama=https%3A//i.imgur.com/O9CBhdM.jpg&autoLoad=true",
          "adjacent_locations": {"location_2", "location_3"}
        },
        "location_2": {
          "url":
              "https://cdn.pannellum.org/2.5/pannellum.htm#panorama=https%3A//i.imgur.com/O9CBhdM.jpg&autoLoad=true",
          "adjacent_locations": {"location_1"}
        },
        "location_3": {
          "url":
              "https://cdn.pannellum.org/2.5/pannellum.htm#panorama=https%3A//i.imgur.com/O9CBhdM.jpg&autoLoad=true",
          "adjacent_locations": {"location_1"}
        }
      }
    };
    final String startURL = mockTourInfo['locations']
            [mockTourInfo['start_location']]['url']
        .toString();
    return Scaffold(
      appBar: AppBar(
        // TODO: The tour name should come from the tour object
        title: Text(widget.tour.tourName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: WebViewX(
        height: safeHeight,
        width: safeWidth,
        // TODO: replace URL with response from API call GET /tour/<tour_id>/
        initialContent: startURL,
        onPageStarted: (url) {
          // This method is called when the WebView starts loading a new page
          debugPrint('Page started loading: $url');
        },
        onWebViewCreated: (controller) {
          webviewController = controller;
        },
      ),
    );
  }
}
