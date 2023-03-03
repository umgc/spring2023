import 'package:flutter/material.dart';


import '../settings/settings_view.dart';
import '../text_search/search_screen.dart';

import 'tour.dart';
import 'tour_details_view.dart';

/// Displays a list of Tours.
class TourListView extends StatelessWidget {
  const TourListView({
    super.key,
    this.items = const [Tour(1), Tour(2), Tour(3)],
  });

  static const routeName = '/';

  final List<Tour> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tours'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: Column(children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SearchScreen(),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 16),
            child: SizedBox(
                height: 200,
                child: ListView.builder(
                  // Providing a restorationId allows the ListView to restore the
                  // scroll position when a user leaves and returns to the app after it
                  // has been killed while running in the background.
                  restorationId: 'tourListView',
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = items[index];

                    return ListTile(
                        title: Text('Tour ${item.id}'),
                        leading: const CircleAvatar(
                          // Display the Flutter Logo image asset.
                          foregroundImage:
                              AssetImage('assets/images/flutter_logo.png'),
                        ),
                        onTap: () {
                          // Navigate to the details page. If the user leaves and returns to
                          // the app after it has been killed while running in the
                          // background, the navigation stack is restored.
                          Navigator.restorablePushNamed(
                            context,
                            TourDetailsView.routeName,
                          );
                        });
                  },
                )))
      ]),
    );
  }
}





