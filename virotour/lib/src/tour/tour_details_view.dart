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
    "id": 3,
    "locations": [
      {
        "location_id": 19,
        "neighbors": [
          {"location_id": 20, "x": 8235, "y": 1125}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_23_27_57/19"
      },
      {
        "location_id": 20,
        "neighbors": [
          {"location_id": 21, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_23_27_57/20"
      },
      {
        "location_id": 21,
        "neighbors": [
          {"location_id": 22, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_23_27_57/21"
      },
      {
        "location_id": 22,
        "neighbors": [
          {"location_id": 23, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_23_27_57/22"
      },
      {
        "location_id": 23,
        "neighbors": [
          {"location_id": 24, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_23_27_57/23"
      },
      {
        "location_id": 24,
        "neighbors": [
          {"location_id": 25, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_23_27_57/24"
      },
      {
        "location_id": 25,
        "neighbors": [
          {"location_id": 26, "x": 6030, "y": 2109}
        ],
        "pano_file_path":
            "https://virotour2023-flask-server.azurewebsites.net/api/tour/images/panoramic-image-file/Air%20Space%2003_21_23_27_57/25"
      }
    ],
    "name": "Air Space 03_21_23_27_57",
    "text_matches": [
      {"content": "97", "location_id": 19, "x": 982, "y": 1516},
      {"content": "56", "location_id": 19, "x": 5093, "y": 2054},
      {"content": "3", "location_id": 19, "x": 942, "y": 1561},
      {"content": "Mr: and Mrs_", "location_id": 20, "x": 2798, "y": 1885},
      {"content": "OME CENTER", "location_id": 20, "x": 5956, "y": 1886},
      {"content": "WELCOME", "location_id": 20, "x": 7959, "y": 1907},
      {"content": "Wekcome Center", "location_id": 20, "x": 2934, "y": 2043},
      {
        "content": "01 Arbus IMAX Theater",
        "location_id": 20,
        "x": 7959,
        "y": 2077
      },
      {"content": "LOWER LEVEL", "location_id": 20, "x": 7959, "y": 2152},
      {
        "content": "Airbus IMAX? Theater @1",
        "location_id": 20,
        "x": 2940,
        "y": 2162
      },
      {"content": ":4 Space Hangar", "location_id": 20, "x": 7932, "y": 2264},
      {
        "content": "7 FRestoration Hanpar",
        "location_id": 20,
        "x": 7942,
        "y": 2302
      },
      {"content": "and Walkway", "location_id": 20, "x": 2954, "y": 1792},
      {"content": "4 Boeing Aviati", "location_id": 20, "x": 2914, "y": 1855},
      {"content": "0 Simulator Rides", "location_id": 20, "x": 2919, "y": 1933},
      {"content": "The Comm", "location_id": 20, "x": 2802, "y": 1959},
      {"content": "UPPER LEVEL", "location_id": 20, "x": 7959, "y": 1966},
      {"content": "~Baby Care Room", "location_id": 20, "x": 2931, "y": 2219},
      {"content": "#81", "location_id": 21, "x": 2672, "y": 1704},
      {
        "content": "Ryan PT-22A Recrue",
        "location_id": 21,
        "x": 3126,
        "y": 2620
      },
      {"content": "Westland E", "location_id": 21, "x": 4138, "y": 2639},
      {"content": "Lysan", "location_id": 21, "x": 4274, "y": 2682},
      {"content": "Blackbird", "location_id": 21, "x": 5753, "y": 2727},
      {"content": "LocHIAL", "location_id": 21, "x": 5556, "y": 2785},
      {"content": "K 0", "location_id": 23, "x": 3882, "y": 1842},
      {"content": "Aire", "location_id": 23, "x": 3879, "y": 1944},
      {"content": "a", "location_id": 23, "x": 4198, "y": 1982},
      {"content": "a n d", "location_id": 23, "x": 4440, "y": 1960},
      {"content": "V i e t n a m", "location_id": 23, "x": 4943, "y": 1954},
      {"content": "in", "location_id": 23, "x": 4229, "y": 2074},
      {"content": "Lim iTe", "location_id": 23, "x": 4412, "y": 2056},
      {"content": "~ar", "location_id": 23, "x": 4719, "y": 2046},
      {"content": "rpower", "location_id": 23, "x": 4036, "y": 2096},
      {"content": "invozvolved", "location_id": 23, "x": 4430, "y": 2158},
      {"content": "conventional", "location_id": 23, "x": 4264, "y": 2206},
      {"content": "weapons:", "location_id": 23, "x": 4358, "y": 2200},
      {"content": "Koredn _ar", "location_id": 23, "x": 4854, "y": 2200},
      {"content": "campaigns", "location_id": 23, "x": 4056, "y": 2220},
      {"content": "waged", "location_id": 23, "x": 4134, "y": 2220},
      {
        "content": " the World War II; ]",
        "location_id": 23,
        "x": 4358,
        "y": 2234
      },
      {
        "content": "formations of heavy",
        "location_id": 23,
        "x": 4028,
        "y": 2258
      },
      {"content": "~seldom u=", "location_id": 23, "x": 3991, "y": 2294},
      {
        "content": "sed to attack target",
        "location_id": 23,
        "x": 4090,
        "y": 2291
      },
      {"content": "trategic assets", "location_id": 23, "x": 4420, "y": 2327},
      {"content": "Neither", "location_id": 23, "x": 4012, "y": 2356},
      {"content": "ulnerable t", "location_id": 23, "x": 4012, "y": 2390},
      {"content": "Their sources of", "location_id": 23, "x": 4196, "y": 2381},
      {"content": "was unwilling to", "location_id": 23, "x": 4355, "y": 2404},
      {"content": "~the Soviet Union", "location_id": 23, "x": 4028, "y": 2424},
      {"content": "~Allied grc", "location_id": 23, "x": 4266, "y": 2444},
      {"content": "Lforces", "location_id": 23, "x": 4365, "y": 2438},
      {
        "content": "These wars were fought",
        "location_id": 23,
        "x": 4056,
        "y": 2462
      },
      {"content": "and bombers", "location_id": 23, "x": 4378, "y": 2474},
      {"content": "Air Force. Navy;", "location_id": 23, "x": 4066, "y": 2492},
      {
        "content": "ided close support",
        "location_id": 23,
        "x": 4070,
        "y": 2530
      },
      {
        "content": "ided battlefield mobility",
        "location_id": 23,
        "x": 4144,
        "y": 2655
      },
      {"content": "solidated", "location_id": 23, "x": 4474, "y": 2750},
      {
        "content": "strategic  airpower",
        "location_id": 23,
        "x": 4172,
        "y": 2774
      },
      {"content": " of carrying", "location_id": 23, "x": 4460, "y": 2786},
      {"content": "Peacemaker", "location_id": 23, "x": 4083, "y": 2804},
      {"content": ": Sovie", "location_id": 23, "x": 4300, "y": 2832},
      {
        "content": "wars into global co",
        "location_id": 23,
        "x": 4185,
        "y": 2866
      },
      {"content": "vation", "location_id": 23, "x": 6164, "y": 1362},
      {"content": "r e", "location_id": 23, "x": 4079, "y": 1997},
      {
        "content": "'strength lay within China and",
        "location_id": 23,
        "x": 4363,
        "y": 2378
      },
      {"content": "assisted by", "location_id": 23, "x": 4434, "y": 2439},
      {"content": "and Marine Cc", "location_id": 23, "x": 4185, "y": 2493},
      {"content": ": Bell UH-[", "location_id": 23, "x": 4448, "y": 2602},
      {
        "content": "of maneuver warfare_",
        "location_id": 23,
        "x": 4413,
        "y": 2641
      },
      {"content": "the Cons", "location_id": 23, "x": 4408, "y": 2765},
      {"content": "'the B-52", "location_id": 23, "x": 4250, "y": 2807}
    ]
  };

  // Grab the first location's location_id for the Pannellum firstScene id.
  static String firstImgId =
      ((jsonExample["locations"]! as List<dynamic>)[0]["location_id"] as int)
          .toString();

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
                    "firstScene": "location_id $firstImgId",            
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
