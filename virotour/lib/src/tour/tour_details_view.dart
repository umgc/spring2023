import 'dart:convert';

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
  String htmlScenes = '';

  static const jsonExample = {
    "description": "test",
    "id": 2,
    "locations": [
      {
        "location_id": 10,
        "neighbors": [],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_21_06_45/10"
      },
      {
        "location_id": 11,
        "neighbors": [
          {"location_id": 10, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_21_06_45/11"
      },
      {
        "location_id": 12,
        "neighbors": [
          {"location_id": 11, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_21_06_45/12"
      },
      {
        "location_id": 13,
        "neighbors": [
          {"location_id": 12, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_21_06_45/13"
      },
      {
        "location_id": 14,
        "neighbors": [
          {"location_id": 13, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_21_06_45/14"
      },
      {
        "location_id": 15,
        "neighbors": [
          {"location_id": 14, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_21_06_45/15"
      },
      {
        "location_id": 16,
        "neighbors": [
          {"location_id": 15, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_21_06_45/16"
      }
    ],
    "name": "Air Space 03_21_21_06_45",
    "text_matches": [
      {"content": "97", "location_id": 10, "x": 982, "y": 1516},
      {"content": "56", "location_id": 10, "x": 5093, "y": 2054},
      {"content": "3", "location_id": 10, "x": 942, "y": 1561},
      {"content": "Mr: and Mrs_", "location_id": 11, "x": 2798, "y": 1885},
      {"content": "OME CENTER", "location_id": 11, "x": 5956, "y": 1886},
      {"content": "WELCOME", "location_id": 11, "x": 7959, "y": 1907},
      {"content": "Wekcome Center", "location_id": 11, "x": 2934, "y": 2043},
      {
        "content": "01 Arbus IMAX Theater",
        "location_id": 11,
        "x": 7959,
        "y": 2077
      },
      {"content": "LOWER LEVEL", "location_id": 11, "x": 7959, "y": 2152},
      {
        "content": "Airbus IMAX? Theater @1",
        "location_id": 11,
        "x": 2940,
        "y": 2162
      },
      {"content": ":4 Space Hangar", "location_id": 11, "x": 7932, "y": 2264},
      {
        "content": "7 FRestoration Hanpar",
        "location_id": 11,
        "x": 7942,
        "y": 2302
      },
      {"content": "and Walkway", "location_id": 11, "x": 2954, "y": 1792},
      {"content": "4 Boeing Aviati", "location_id": 11, "x": 2914, "y": 1855},
      {"content": "0 Simulator Rides", "location_id": 11, "x": 2919, "y": 1933},
      {"content": "The Comm", "location_id": 11, "x": 2802, "y": 1959},
      {"content": "UPPER LEVEL", "location_id": 11, "x": 7959, "y": 1966},
      {"content": "~Baby Care Room", "location_id": 11, "x": 2931, "y": 2219},
      {"content": "#81", "location_id": 12, "x": 2672, "y": 1704},
      {
        "content": "Ryan PT-22A Recrue",
        "location_id": 12,
        "x": 3126,
        "y": 2620
      },
      {"content": "Westland E", "location_id": 12, "x": 4138, "y": 2639},
      {"content": "Lysan", "location_id": 12, "x": 4274, "y": 2682},
      {"content": "Blackbird", "location_id": 12, "x": 5753, "y": 2727},
      {"content": "LocHIAL", "location_id": 12, "x": 5556, "y": 2785}
    ]
  };

  String buildScenes(String jsonString) {
    Map<String, dynamic> jsonData =
        jsonDecode(jsonString) as Map<String, dynamic>;

    List<dynamic> locations = List<dynamic>.from(jsonData['locations'] as List);
    List<dynamic> textMatches =
        List<dynamic>.from(jsonData['text_matches'] as List);

    Map<String, dynamic> scenes = {};

    for (var location in locations) {
      int locationId = location['location_id'] as int;
      String panoFilePath = location['pano_file_path'] as String? ??
          "https://i.imgur.com/uo81tax.png";

      List<Map<String, dynamic>> hotspots = [];

      for (var neighbor in location['neighbors']) {
        hotspots.add({
          'pitch': neighbor['x'],
          'yaw': neighbor['y'],
          'type': 'scene',
          'text': (neighbor['location_id'] as int).toString(),
          'sceneId': (neighbor['location_id'] as int).toString()
        });
      }

      for (var textMatch in textMatches) {
        if (textMatch['location_id'] == locationId) {
          hotspots.add({
            'pitch': textMatch['x'],
            'yaw': textMatch['y'],
            'type': 'info',
            'text': textMatch['content']
          });
        }
      }

      scenes['location_id $locationId'] = {
        'title': 'Location $locationId',
        'hfov': 180,
        'pitch': 0,
        'yaw': 0,
        'type': 'equirectangular',
        'panorama': panoFilePath,
        'hotspots': hotspots
      };
    }

    return '"scenes": ${jsonEncode(scenes)}';
  }

  @override
  void initState() {
    super.initState();
    initializeHtmlScenes();
  }

  void initializeHtmlScenes() {
    htmlScenes = buildScenes(jsonEncode(jsonExample));
    print(htmlScenes);
  }

  Future<String> getTourHtml(String htmlScenes) async {
    final tourHtml = """
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
                    "firstScene": "location_id 10",            
                    "sceneFadeDuration": 1000        
                },        
                $htmlScenes
            });    
        </script>    
    </body>    
    </html>
    """;
    return tourHtml;
  }

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
      body: FutureBuilder<String>(
        future: getTourHtml(htmlScenes),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return WebViewX(
              height: safeHeight,
              width: safeWidth,
              initialContent: snapshot.data!,
              initialSourceType: SourceType.html,
              onPageStarted: (url) {
                debugPrint('Page started loading: $url');
              },
              onWebResourceError: (error) {
                debugPrint('WebViewX error: ${error.description}');
              }, // Set the background color            );
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
