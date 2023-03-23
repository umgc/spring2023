import 'package:flutter/material.dart';

class GlowEffectView extends StatefulWidget {
  const GlowEffectView({super.key});
  @override
  SliderState createState() => SliderState();
}

class SliderState extends State<GlowEffectView> {
  double lighting = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Viro Tour')),
        body: Column(
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
                    fit: BoxFit.cover,
                  ),
                  ColoredBox(
                    color: Colors.black.withOpacity(lighting),
                  ),
                ],
              ),
            ),
            Slider(
              value: lighting,
              divisions: 20,
              label: lighting.toString(),
              activeColor: Colors.black,
              thumbColor: Colors.orange,
              onChanged: (value) {
                setState(() {
                  lighting = value;
                });
              },
            ),
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
