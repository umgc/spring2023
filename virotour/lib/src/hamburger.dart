import 'package:flutter/material.dart';
import 'package:virotour/src/search.dart';
import 'package:virotour/src/tour/tour_list_view.dart';

class Hamburger extends StatelessWidget {
  const Hamburger({super.key});

  void _showPopupMenu(BuildContext context) async {
    String? selected = await showMenu(
      context: context,
      color: Colors.blue,
      position: const RelativeRect.fromLTRB(0.0, 56, 25.0, 0.0),
      //position where you want to show the menu on screen
      items: [
        PopupMenuItem<String>(
          value: 'View Tours',
          child: Row(
            children: const <Widget>[
              Icon(Icons.list, color: Colors.white),
              Text('  View Tours', style: TextStyle(color: Colors.white))
            ],
          ),
        ),
        const PopupMenuDivider(height: 2),
        PopupMenuItem<String>(
          value: 'Create Tour',
          child: Row(
            children: const <Widget>[
              Icon(Icons.add, color: Colors.white),
              Text('  Create Tour', style: TextStyle(color: Colors.white))
            ],
          ),
        ),
        const PopupMenuDivider(height: 2),
        PopupMenuItem<String>(
          value: 'Search',
          child: Row(
            children: const <Widget>[
              Icon(Icons.search, color: Colors.white),
              Text(
                '  Search',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ],
      elevation: 8.0,
    );

    if (selected == 'Create Tour') {
      showSnackBar('Should go to Create Tour Page', context);
      //Navigator.restorablePushNamed(context, CreateTour.routeName);
    } else if (selected == 'Search') {
      // Navigate to the search page here
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    } else if (selected == 'View Tours') {
      Navigator.restorablePushNamed(context, TourListView.routeName);
    } else {
      //nothing here, only used for testing
      // showSnackBar('menu exit', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: Colors.white),
      onPressed: () async {
        //display option here
        _showPopupMenu(context);
      },
    );
  }

  //for testing purposes only
  void showSnackBar(String content, BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(content),
          duration: const Duration(seconds: 1),
        ),
      );
  }
}
