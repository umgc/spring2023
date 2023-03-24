import 'package:flutter/material.dart';
import 'package:virotour/src/settings/settings_view.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:webviewx/webviewx.dart';

class TourDetailsView extends StatefulWidget {
  const TourDetailsView({super.key, required this.tour});
  static const routeName = '/tour';
  final Tour tour;

  @override
  State<TourDetailsView> createState() => _TourDetailsViewState();
}

class _TourDetailsViewState extends State<TourDetailsView> {
  late WebViewXController webviewController;

  static const image1 = "https://i.imgur.com/igGyWbz.jpg";
  static const image2 = "https://i.imgur.com/O9CBhdM.jpg";
  static const image3 = "https://i.imgur.com/yrhSmSh.jpg";
  static const image4 = "https://i.imgur.com/9cD0MWo.jpg";
  static const image5 = "https://i.imgur.com/1Ptnx3d.jpg";
  static const image6 = "https://i.imgur.com/Uo8FHwg.jpg";

  static const hotSpots1 = """
  "hotSpots": [
    {
        "pitch": 0,
        "yaw":0,
        "type": "scene",
        "text": "Main Hall",
        "sceneId": "mainHall",
        "targetYaw": 0,
        "targetPitch": 0
    }
  ]
  """;

  static const hotSpots2 = """
    "hotSpots": [
      {
          "pitch": 0,
          "yaw": 250,
          "type": "scene",
          "text": "Second Location",
          "sceneId": "hallLeft"
      },
      {
          "pitch": 0,
          "yaw": 180,
          "type": "scene",
          "text": "Main Entrance",
          "sceneId": "mainEntrance"
      },
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
  static const hotSpot3 = """
  "hotSpots": [
    {
        "pitch": 12,
        "yaw": 115,
        "type": "scene",
        "text": "First Location",
        "sceneId": "mainHall",
        "targetYaw": -23,
        "targetPitch": 2
    },
    {
        "pitch": -8,
        "yaw": 90,
        "type": "scene",
        "text": "Blackbird",
        "sceneId": "blackbird",
        "targetYaw": 50,
        "targetPitch": 2
    }
  ]
  """;

  static const hotSpot4 = """
  "hotSpots": [
      {
          "pitch": 5,
          "yaw": 260,
          "type": "scene",
          "text": "Second Location",
          "sceneId": "hallLeft"
      },
      {
          "pitch": 0,
          "yaw": 30,
          "type": "scene",
          "text": "Korea Vietnam",
          "sceneId": "koreaVietnam"
      },
      {
          "pitch": 0,
          "yaw": 5,
          "type": "scene",
          "text": "Space Shuttle",
          "sceneId": "spaceShuttle"
      },
  ]
  """;

  static const hotSpot5 = """
  "hotSpots": [
      {
          "pitch": 0,
          "yaw": 210,
          "type": "scene",
          "text": "Blackbird",
          "sceneId": "blackbird"
      },
  ]
  """;

  static const hotSpot6 = """
  "hotSpots": [
      {
          "pitch": 0,
          "yaw": 180,
          "type": "scene",
          "text": "Blackbird",
          "sceneId": "blackbird"
      },
  ]
  """;

  static const tourHtml = """
  <!DOCTYPE HTML>
  <html>
  <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Tour</title>
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
    "autoLoad": true,   
      "default": {
          "firstScene": "mainEntrance",
          "sceneFadeDuration": 1000
      },
      "scenes": {
        "mainEntrance": {
              "title": "Main Entrance",
              "hfov": 180,
              "pitch": 0,
              "yaw": 0,
              "type": "equirectangular",
              "panorama": "$image1",
              $hotSpots1
          },
          "mainHall": {
              "title": "Main Hall",
              "hfov": 180,
              "pitch": 0,
              "yaw": 0,
              "type": "equirectangular",
              "panorama": "$image2",
              $hotSpots2
          },
          "hallLeft": {
              "title": "Walkway",
              "hfov": 180,
              "yaw": 0,
              "type": "equirectangular",
              "panorama": "$image3",
              $hotSpot3
          },
          "blackbird": {
              "title": "Blackbird",
              "hfov": 180,
              "yaw": 0,
              "type": "equirectangular",
              "panorama": "$image4",
              $hotSpot4
          },
          "koreaVietnam": {
              "title": "Korea Vietnam",
              "hfov": 180,
              "yaw": 0,
              "type": "equirectangular",
              "panorama": "$image5",
              $hotSpot5
          },
          "spaceShuttle": {
              "title": "Space Shuttle",
              "hfov": 180,
              "yaw": 0,
              "type": "equirectangular",
              "panorama": "$image6",
              $hotSpot6
          }
      }
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

    return Scaffold(
      appBar: AppBar(
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
