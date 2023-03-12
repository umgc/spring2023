import 'package:flutter/material.dart';
import 'package:virotour/src/tour/tour_details_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String searchQuery;
  // we will need to create a function here that grabs ALL the tour data for us to filter through
  List<dynamic> mockItems = [
    {
      "name": "Virtual Tour Test 1",
      "description": "This is the first tour",
      "id": 1
    },
    {
      "name": "Virtual Tour Test 2",
      "description": "This happens to be the second tour",
      "id": 2
    },
    {
      "name": "Virtual Tour Test 3",
      "description": "Look out, here comes the third tour",
      "id": 3
    }
  ];
  List<dynamic> filteredItems = [];
  List<Map<String, dynamic>> items = [];

  final _searchController = TextEditingController();

  void searchData() {
    setState(() {
      filteredItems = [];
      for (var item in items) {
        String itemName = item['name'].toString().toLowerCase();
        String itemDescription = item['description'].toString().toLowerCase();
        String searchQueryLower = searchQuery.toLowerCase();
        if (itemName.contains(searchQueryLower) ||
            itemDescription.contains(searchQueryLower)) {
          filteredItems.add(item);
        }
      }
    });
  }

  void clearSearch() {
    setState(() {
      _searchController.clear();
      searchQuery = '';
      filteredItems = [];
    });
  }

  @override
  void initState() {
    super.initState();
    items = mockItems.map((e) => e as Map<String, dynamic>).toList();
    filteredItems = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                      searchData();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter search query',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearSearch,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TourDetailsView(),
                          ),
                        );
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TourDetailsView(),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(filteredItems[index]['name'] as String),
                          subtitle: Text(
                            filteredItems[index]['description'] as String,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
