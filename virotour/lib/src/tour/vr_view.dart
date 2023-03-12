import 'package:flutter/material.dart';
import '../settings/settings_view.dart';

//This page is for demonstration purpose only,
// can be removed later on

class GlowVr extends StatelessWidget {
  const GlowVr({super.key});
  static const routeName = '/glow_vr';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('VR View'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(28.0),
          child: Text(
            "Links to VR View",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.blueGrey,
            ),
          ),
        ),);
  }
}
