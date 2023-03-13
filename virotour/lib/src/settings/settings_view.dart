import 'package:flutter/material.dart';
import 'package:virotour/src/hamburger.dart';
import 'package:virotour/src/settings/settings_controller.dart';

import '../tour/glow_effect.dart';
import '../tour/tour_list_view.dart';
import '../tour/vr_view.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: const Hamburger(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.restorablePushNamed(context, TourListView.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 60.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [


            //Glow Effect Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViroTour()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(70.0, 35.0),
                textStyle: const TextStyle(fontSize: 12),
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text("Glow Effect"),
            ),


            //VR View Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GlowVr()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100.0, 35.0),
                textStyle: const TextStyle(fontSize: 12),
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text("VR View"),
            ),

            // Glue the SettingsController to the theme selection DropdownButton.
            //
            // When a user selects a theme from the dropdown list, the
            // SettingsController is updated, which rebuilds the MaterialApp.
            DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(
                    'System Theme',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(
                    'Light Theme',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(
                    'Dark Theme',
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
