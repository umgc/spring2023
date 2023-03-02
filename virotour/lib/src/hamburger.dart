
import 'package:flutter/material.dart';
import 'package:virotour/src/tour/tour_list_view.dart';
import 'package:virotour/src/tour/tour_edit_view.dart';
class Hamburger extends StatelessWidget {

  Future<void> _showPopupMenu(BuildContext context) async {
    String? selected = await showMenu(
      context: context,
      color: Colors.blue,
      position: RelativeRect.fromLTRB(0.0, 56, 25.0, 0.0),
      //position where you want to show the menu on screen
      items: [
        PopupMenuItem<String>(
            child: Row(children: const <Widget>[
              Icon(Icons.public, color: Colors.white),
              const Text('  Create Tour', style: TextStyle(color: Colors.white))
            ]), value: 'Create Tour'),
        PopupMenuDivider(
            height: 2
        ),
        PopupMenuItem<String>(
            child: Row(children: const <Widget>[
              Icon(Icons.add_circle_outline, color: Colors.white),
              const Text('  View Tour', style: TextStyle(color: Colors.white))
            ]), value: 'View Tour'),
        PopupMenuDivider(
            height: 2
        ),
        PopupMenuItem<String>(
            child: Row(children: const <Widget>[
              Icon(Icons.edit, color: Colors.white),
              const Text('  Edit Tour', style: TextStyle(color: Colors.white))
            ]), value: 'Edit Tour'),
        PopupMenuDivider(
            height: 2
        ),
        PopupMenuItem<String>(
            child: Row(children: const <Widget>[
              Icon(Icons.publish, color: Colors.white),
              const Text(
                  '  Publish Tour', style: TextStyle(color: Colors.white))
            ]), value: 'Publish Tour'),
      ],
      elevation: 8.0,
    );

    // Not entirely sure how to navigate the page tree. Tried to make the app into a materialApp to have named routes
    //but that didn't seem to work properly. Will figure this out later in the week.
    if (selected == 'Create Tour') {
      showSnackBar('Should go to Create Tour Page', context);
      //Navigator.restorablePushNamed(context, CreateTour.routeName);
    }
    else if (selected == 'View Tour') {
      //doesn't work
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    else if (selected == 'Edit Tour') {
      Navigator.restorablePushNamed(context, TourEditView.routeName);

    }
    else if (selected == 'Publish Tour') {
      showSnackBar('Should go to publish Tour Page', context);
      //Navigator.restorablePushNamed(context, PublishTour.routeName);
    }
    else {
      //nothing here, only used for testing
      // showSnackBar('menu exit', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () async {
      //display option here
      _showPopupMenu(context);
    });
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