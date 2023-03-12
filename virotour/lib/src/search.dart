import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virotour/src/tour/tour_details_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = "";
  List<Map<String, dynamic>> items = [];
  List<dynamic> filteredItems = [];

  final _searchController = TextEditingController();

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8081/api/tours'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final dataLength = data["tours"].length;

      final tours = data['tours'] as List<dynamic>;

      setState(() {
        items = tours.map((tour) => tour as Map<String, dynamic>).toList();
      });
    } else {
      throw Exception("Failed to load tour data!");
    }
  }

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
    fetchData();
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
            if (searchQuery.isNotEmpty)
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
