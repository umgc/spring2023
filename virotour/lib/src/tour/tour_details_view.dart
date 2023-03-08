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
        actions: [                 //wheel_menu action start
          PopupMenuButton<int>(
            color: Colors.lightBlue[600],
            icon: const Icon(Icons.settings, color: Colors.white,),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
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
              const PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
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
  //wheel_menu onSelected
  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.restorablePushNamed(
          context, TourDetailsView.routeName,); // 'Glow Effect'
        break;
      case 1:
        Navigator.restorablePushNamed(
          context, TourDetailsView.routeName,); // 'VR View'
    }
  }
}
