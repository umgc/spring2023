import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webviewx/webviewx.dart';

/// NOTE: This feature is not integrated with the app. Once the users go to this
/// view, it actually loads a new 360 image.
/// TODO: Integrate this feature with the app. Potentially make the wheel menu
/// show the slider in the tour details view.

double lighting = 0;

class ViroTour extends StatefulWidget {
  ViroTour({Key? key}) : super(key: key);
  @override
  SliderState createState() => SliderState();
}

class SliderState extends State<ViroTour> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Glow Effect')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.bottomCenter,
            ),
            SizedBox(
              height: 520,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  WebViewX(
                    height: 520,
                    width: 1600,
                    // TODO: replace URL with response from API call GET /tour/<tour_id>/
                    initialContent:
                        'https://cdn.pannellum.org/2.5/pannellum.htm#panorama=https%3A//i.imgur.com/O9CBhdM.jpg&autoLoad=true',
                    onPageStarted: (url) {
                      // This method is called when the WebView starts loading a new page
                      debugPrint('Page started loading: $url');
                    },
                    onWebViewCreated: (controller) {
                      var webviewController = controller;
                    },
                  ),
                  ColoredBox(
                    color: Colors.white.withAlpha(lighting.toInt()),
                  ),
                ],
              ),
            ),
            Slider(
                value: lighting,
                min: 0,
                max: 255,
                divisions: 17,
                label: lighting.toString(),
                activeColor: Colors.black,
                thumbColor: Colors.orange,
                onChanged: (value) {
                  setState(() {
                    lighting = value;
                  });
                }),
            const Text(
              "Change the image lighting using slider bar",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
