import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:webviewx/webviewx.dart';
import 'package:http/http.dart' as http;

import '../helpers/ip_handler.dart';
import '../settings/settings_view.dart';

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

  static const tourHtml = "<h2> Hello, world! </h2>";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final padding = MediaQuery.of(context).padding;
    final safeHeight = height - padding.top - padding.bottom;
    final safeWidth = width - padding.left - padding.right;

    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final tourId = arguments['id'] as String;
    final tourName = arguments['name'] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(tourName),
      ),
      body: WebViewX(
        height: safeHeight,
        width: safeWidth,
        initialContent: tourHtml,
        onPageStarted: (url) {
          debugPrint('Page started loading: $url');
        },
        onWebResourceError: (error) {
          debugPrint('WebViewX error: ${error.description}');
        }, // Set the background color
      ),
    );
  }
}
