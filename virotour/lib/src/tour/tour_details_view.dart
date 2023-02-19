import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

/// Displays detailed information about a Tour.
class TourDetailsView extends StatefulWidget {
  const TourDetailsView({super.key});
  static const routeName = '/tour';

  @override
  State<TourDetailsView> createState() => _TourDetailsViewState();
}

class _TourDetailsViewState extends State<TourDetailsView> {
  late WebViewXController webviewController;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final padding = MediaQuery.of(context).padding;
    final safeHeight = height - padding.top - padding.bottom;
    final safeWidth = width - padding.left - padding.right;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour Details / Tour Name'),
      ),
      body: WebViewX(
        height: safeHeight,
        width: safeWidth,
        // TODO: replace URL with response from API call GET /tour/<tour_id>/
        initialContent:
            'https://cdn.pannellum.org/2.5/pannellum.htm#panorama=https%3A//i.imgur.com/O9CBhdM.jpg&autoLoad=true',
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
