import 'package:flutter/material.dart';

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
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  Future<List<String>> _fetchSearchResults(String query) async {
    // Mock API call to fetch search results
    await Future.delayed(const Duration(seconds: 1));

    // In this example, we return a list of words that contain the search query
    final List<String> words = ['museum', 'house', 'park', 'public places'];
    return words.where((word) => word.contains(query)).toList();
  }

  void _onSearchQueryChanged(String query) {
    if (query.isNotEmpty) {
      _fetchSearchResults(query).then((results) {
        setState(() {
          _searchResults = results;
        });
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Hotspots'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchQueryChanged,
            decoration: const InputDecoration(
              hintText: 'Type to search for informational hotspots',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                final result = _searchResults[index];
                return ListTile(
                  title: Text(result),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
