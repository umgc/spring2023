import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virotour/src/helpers/ip_handler.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:virotour/src/tour/tour_details_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = "";
  List<Map<String, dynamic>> items = [];
  List<Tour> filteredItems = [];

  final _searchController = TextEditingController();

  Future<void> fetchData() async {
    final http.Response response = await IPHandler().tryEndpoint('/api/tours');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final tours = data['tours'] as List<dynamic>;

      setState(() {
        items = tours.map((tour) => tour as Map<String, dynamic>).toList();
      });

      if (items.isEmpty) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('No Tours'),
            content: const Text('There are currently no tours to search for.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      throw Exception('Failed to load tour data!');
    }
  }

  void searchData() {
    setState(() {
      filteredItems = [];
      for (final item in items) {
        final String itemName = item['name'].toString().toLowerCase();
        final String itemDescription =
            item['description'].toString().toLowerCase();
        final String searchQueryLower = searchQuery.toLowerCase();
        if (itemName.contains(searchQueryLower) ||
            itemDescription.contains(searchQueryLower)) {
          final Tour tour = Tour(
            id: item['id']
                .toString(), // Add .toString() to ensure it's a string
            tourName: item['name'] as String,
            description: item['description'] as String,
          );
          filteredItems.add(tour);
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
        title: const Text('Search Tours'),
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
                              builder: (context) =>
                                  TourDetailsView(tour: filteredItems[index]),
                            ),
                          );
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TourDetailsView(tour: filteredItems[index]),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(filteredItems[index].tourName),
                            subtitle: Text(filteredItems[index].description),
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
