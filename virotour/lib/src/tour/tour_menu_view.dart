import 'package:flutter/material.dart';
import 'package:virotour/src/settings/settings_view.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:virotour/src/tour/tour_list_view.dart';

class TourMenuView extends StatelessWidget {
  const TourMenuView({
    super.key
  });

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Create tour row
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // Not sure if this should be hard-coded
              height: 40,
              width: 300,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: color),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.add_a_photo, color: Colors.white),
                    Padding(
                      padding: EdgeInsets.only(left:10.0),
                      child: Text(
                        "Create tour",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      ">",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                onPressed: () {
                // TODO: This needs to be updated to route to the create tour page
                //Navigator.restorablePushNamed(context, );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // View tour row
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // Not sure if this should be hard-coded
              height: 40,
              width: 300,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: color),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.pageview, color: Colors.white),
                    Padding(
                      padding: EdgeInsets.only(left:10.0),
                      child: Text(
                        "View tour",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      ">",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.restorablePushNamed(context, TourListView.routeName);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // Edit tour row
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // Not sure if this should be hard-coded
              height: 40,
              width: 300,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: color),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    Padding(
                      padding: EdgeInsets.only(left:10.0),
                      child: Text(
                        "Edit tour",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      ">",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                onPressed: () {
                  // TODO: This needs to be updated to route to the edit tour page
                  //Navigator.restorablePushNamed(context, );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // Publish tour row
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // Not sure if this should be hard-coded
              height: 40,
              width: 300,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: color),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.publish, color: Colors.white),
                    Padding(
                      padding: EdgeInsets.only(left:10.0),
                      child: Text(
                        "Publish tour",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      ">",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                onPressed: () {
                  // TODO: This needs to be updated to route to the publish tour page
                  //Navigator.restorablePushNamed(context, );
                },
              ),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour Menu'),
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

      body: ListView(
        children: [
          buttonSection
        ]
      )
    );
  }
}
