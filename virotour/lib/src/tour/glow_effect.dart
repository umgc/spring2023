import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return Scaffold(
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
                  Image.asset(
                      'assets/images/screenshots/app_screenshot_Chrome_v1.0.png',
                      fit: BoxFit.cover,),
                  ColoredBox(
                    color: Colors.black.withOpacity(lighting),
                  ),
                  // const Text("Change slider"),
                ],
              ),
            ),
            Slider(
                value: lighting,
                min: 0,
                max: 1,
                divisions: 20,
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
      );
      }
}
