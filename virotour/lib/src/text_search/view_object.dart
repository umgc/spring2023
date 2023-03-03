import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewObject extends StatelessWidget {
  String url;

  ViewObject({super.key, required String this.url}) {
    Future<http.Response> res = fetchData("");
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(url, width: 300, height: 150);
  }

  final urll = Uri.https('google.com', '?q=tour/search/WWI');

  Future<http.Response> fetchData(var url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load the tours, please try again");
    }
  }
}
