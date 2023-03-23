import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webviewx/webviewx.dart';
//import 'dart:convert';


double lighting = 0;

void main() {
  runApp(ViroTour());
}
class ViroTour extends StatefulWidget {
  ViroTour({Key? key}) : super(key: key);
  @override
  SliderState createState() => SliderState();
}
class SliderState extends State<ViroTour> {
  @override
  Widget build(BuildContext context) {
/*
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final padding = MediaQuery.of(context).padding;
    final safeHeight = height - padding.top - padding.bottom;
    final safeWidth = width - padding.left - padding.right;

 */
    return  MaterialApp(
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

                  //Image.asset('assets/plane.png',
                  //    fit: BoxFit.cover
                  ),
                  ColoredBox(
                    color: Colors.white.withAlpha(lighting.toInt()),
                    //color: Colors.black.withOpacity(lighting),
                  ),
                  // const Text("Change slider"),
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