import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class TourDetailsView extends StatefulWidget {
  const TourDetailsView({super.key});
  static const routeName = '/tour';

  @override
  State<TourDetailsView> createState() => _TourDetailsViewState();
}

class _TourDetailsViewState extends State<TourDetailsView> {
  late WebViewXController webviewController;

  static const images = "https://i.imgur.com/O9CBhdM.jpg";

  static const hotSpots = """
    "hotSpots": [
      {
          "pitch": 5.0,
          "yaw": 40,
          "type": "info",
          "text": "Corsair Fighter Plane",
          "URL": "https://en.wikipedia.org/wiki/Vought_F4U_Corsair"
      },
      {
          "pitch": -12,
          "yaw": 222,
          "type": "info",
          "text": "Walkway"
      },
      {
          "pitch": 30,
          "yaw": 180,
          "type": "info",
          "text": "Biplane with tag N22E"
      }
    ] 
  """;

  static const tourHtml = """
    <!DOCTYPE HTML>
    <html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hot spots</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/pannellum@2.5.6/build/pannellum.css"/>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/pannellum@2.5.6/build/pannellum.js"></script>
        <style>
        #panorama {
              position: absolute;
              top: 0;
              bottom: 0;
              left: 0;
              right: 0;
              width: 100%;
              height: 100%;
        }
        </style>
    </head>
    <body>

    <div id="panorama"></div>
    <script>
    pannellum.viewer('panorama', {
        "type": "equirectangular",
        "panorama": "$images",
        "autoLoad": true,
        /*
        * Uncomment the next line to print the coordinates of mouse clicks
        * to the browser's developer console, which makes it much easier
        * to figure out where to place hot spots. Always remove it when
        * finished, though.
        */
        //"hotSpotDebug": true,
        $hotSpots
    });
    </script>

    </body>
    </html>
  """;

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
        initialSourceType: SourceType.html,
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
