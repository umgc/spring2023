import 'package:flutter/material.dart';
import 'package:virotour/src/navbar/hamburger.dart';
import 'package:virotour/src/tour/tour.dart';

import '../settings/settings_view.dart';

class HotspotSearchView extends StatefulWidget {
  const HotspotSearchView({
    super.key,
    required this.items,
  });

  static const routeName = '/search_hotspots';

  final List<Map<String, String>> items;

  @override
  _HotspotSearchViewState createState() => _HotspotSearchViewState();
}

class _HotspotSearchViewState extends State<HotspotSearchView> {
  late Future<List<Tour>> _searchResult;
  final _searchTerm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Hotspots'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 16),
            child: TextField(
              controller: _searchTerm,
              onChanged: (text) {
                // addButton();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: 'Enter a search term',
                prefixIcon: Padding(
                  padding:
                      EdgeInsets.only(top: 0), // add padding to adjust icon
                  child: Icon(Icons.search),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
