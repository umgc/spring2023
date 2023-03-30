import 'package:flutter/material.dart';
import 'package:virotour/src/search/hotspot_search_view.dart';
import 'package:virotour/src/settings/settings_controller.dart';
import 'package:virotour/src/settings/settings_view.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:virotour/src/tour/tour_details_view.dart';
import 'package:virotour/src/tour/tour_list_view.dart';
import 'package:virotour/src/tour/tour_create_view.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case TourDetailsView.routeName:
                    return TourDetailsView(
                      tour: Tour(id: '', tourName: '', description: ''),
                    );
                  case HotspotSearchView.routeName:
                    return const HotspotSearchView(
                      items: [],
                    );
                  case TourListView.routeName:
                    return const TourListView(
                        items: []
                    );
                  case TourCreateView.routeName:
                    return const TourCreateView();
                  default:
                    return const TourListView(
                      items: [],
                    );
                }
              },
            );
          },
        );
      },
    );
  }
}
