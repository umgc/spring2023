import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:webviewx/webviewx.dart';
import 'package:http/http.dart' as http;

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

  Future<List<Tour>> getTourInfo() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.180:8081/api/tour/${widget.tour.id}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print('where is $data');
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final padding = MediaQuery.of(context).padding;
    final safeHeight = height - padding.top - padding.bottom;
    final safeWidth = width - padding.left - padding.right;

    // final tourInfo = getTourInfo();
    // print('Got this tour: $tourInfo');
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
