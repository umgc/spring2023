import 'package:flutter/material.dart';
import 'package:virotour/src/settings/settings_view.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:virotour/src/tour/tour_details_view.dart';

class TourListView extends StatelessWidget {
  const TourListView({
    super.key,
    // TODO: Get the list of tours from GET /
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
          PopupMenuButton<int>(
            color: Colors.lightBlue[600],
            icon: const Icon(Icons.settings),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.sunny,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 15.0),
                      Text(
                        'Glow Effect',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  )),
              PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(
                        Icons
                            .voicemail_outlined, //this icon is used because VR view icon is missing in material apps
                        color: Colors.white70,
                      ),
                      SizedBox(width: 15.0),
                      Text(
                        'VR View',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  )),
            ],
          )

          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   onPressed: () {
          //     // Navigate to the settings page. If the user leaves and returns
          //     // to the app after it has been killed while running in the
          //     // background, the navigation stack is restored.
          //     Navigator.restorablePushNamed(context, SettingsView.routeName);
          //   },
          // ),

        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'tourListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
            // TODO: Show tour name
            title: Text('Tour ${item.id}'),
            leading: const CircleAvatar(
              foregroundImage: AssetImage('assets/images/virotour_logo.png'),
            ),
            // TODO: ontap = call GET /tour/<tour_id>
            onTap: () {
              // Navigate to the details page. If the user leaves and returns to
              // the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(
                context,
                TourDetailsView.routeName,
              );
            },
          );
        },
      ),
    );
  }


  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.restorablePushNamed(
            context, SettingsView.routeName,); //Place holder for 'Glow Effect'
        break;
      case 1:
        Navigator.restorablePushNamed(
            context, SettingsView.routeName,); //Place holder for 'VR View'
    }
  }
}
