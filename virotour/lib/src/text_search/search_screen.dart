import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:virotour/src/text_search/Search_results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => SearchText();
}

class SearchText extends State<SearchScreen> {
  SearchText();

  final _searchTerm = TextEditingController();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 16),
          child: TextField(
            controller: _searchTerm,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: 'Enter a search term',
                prefixIcon: Padding(
                  padding:
                  EdgeInsets.only(top: 0), // add padding to adjust icon
                  child: Icon(Icons.search),
                )),
            onSubmitted: (value) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SearchResults(searchTerm:_searchTerm.text)));
            },
          ),
        ),
      ],
    );
  }

  Future<http.Response> fetchData() async {
    String searchTerm = _searchTerm.text;
    final url = Uri.https('virotour.com', '/search/$searchTerm');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load the tours, please try again");
    }
  }
}