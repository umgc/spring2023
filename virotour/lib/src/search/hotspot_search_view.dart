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
  List<Map<String, String>>? _searchResults;

  List<Map<String, String>>? _fetchSearchResults(String query) {
    // Mock API call to fetch search results
    // await Future.delayed(const Duration(seconds: 1));

    // In this example, we return a list of words that contain the search query
    final List<Map<String, List<Map<String, String>>>> items = [
      {
        "painting": [
          {"description": "Painting 1", "url": "URL to painting 1"}
        ]
      },
      {
        "vase": [
          {"description": "Vase 1", "url": "URL to vase 1"},
          {"description": "Vase 2", "url": "URL to vase 2"}
        ]
      },
      {"sculpture": []},
    ];

    final matchedItem = items.firstWhere(
      (item) => item.containsKey(query),
      orElse: () => {},
    );
    if (matchedItem.isEmpty) {
      return null;
    }
    final results = matchedItem[query] as List<Map<String, String>>?;
    return results;
  }

  void _onSearchQueryChanged(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _searchResults = _fetchSearchResults(query);
      });
    } else {
      setState(() {
        _searchResults = null;
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
              itemCount: _searchResults?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final result = _searchResults?[index];
                return ListTile(
                  title: Text(result?['description'] ?? ''),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content: Text("This should go to: ${result!['url']}"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
