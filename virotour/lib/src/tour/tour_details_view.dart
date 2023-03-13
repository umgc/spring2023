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

  static const image1 = "https://i.imgur.com/O9CBhdM.jpg";
  static const image2 = "https://i.imgur.com/yrhSmSh.jpg";

  static const hotSpots1 = """
    "hotSpots": [
      {
          "pitch": 0,
          "yaw": 250,
          "type": "scene",
          "text": "Second Location",
          "sceneId": "second"
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
  static const hotSpot2 = """
  "hotSpots": [
    {
        "pitch": 12,
        "yaw": 115,
        "type": "scene",
        "text": "First Location",
        "sceneId": "entrance",
        "targetYaw": -23,
        "targetPitch": 2
    }
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
        "firstScene": "entrance",
        "sceneFadeDuration": 1000
    },

    "scenes": {
        "entrance": {
            "title": "Main entrance",
            "hfov": 180,
            "pitch": 0,
            "yaw": 0,
            "type": "equirectangular",
            "panorama": "$image1",
            $hotSpots1
        },

        "second": {
            "title": "Second location",
            "hfov": 180,
            "yaw": 0,
            "type": "equirectangular",
            "panorama": "$image2",
            $hotSpot2
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
