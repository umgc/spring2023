import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:virotour/src/text_search/search_object.dart';
import 'package:virotour/src/text_search/view_object.dart';

class SearchResults extends StatelessWidget {
  String searchTerm = "";

  SearchResults({super.key, required this.searchTerm}){
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const viroTitle = 'Search Tours';
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(viroTitle),
        ),
        body: ResultsList(searchTerm: searchTerm),
      ),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
    );
  }

}

class ResultsList extends StatelessWidget {
  String searchTerm="";
  ResultsList({super.key,required  String searchTerm}){fetchData();}


  List<SearchObject> searches = [
    SearchObject(
        "CLI_34343",
        "Spitfire",
        "The most unique fighter plane of the world war 2",
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.fHTe501cQuqKFGM8CkgDhQHaEK%26pid%3DApi&f=1&ipt=ca477fbe92ec14ba787dbebc2338f2c8968932a6e2e5169632314bf3b1b1823c&ipo=images"),
    SearchObject("CMO_89877", "DC-10 tankers", "Aerial fuel tankers",
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.scramble.nl%2Fimages%2Fnews%2F2021%2Ffebruary%2FDC10-TankerAirCarrier.jpg&f=1&nofb=1&ipt=81a85496d3cfd32a7cd8d25fdd72b5d98ec9356931382d5ee053c8264498ff9e&ipo=images")
  ];

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Results',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.black)),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 16),
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: searches.length,
              itemBuilder: (context, i) {
                String url = searches[i].itemLocation;
                Image img = Image.network(url, fit: BoxFit.cover);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                    img.image, // No matter how big it is, it won't overflow
                  ),
                  trailing: Text(
                    "${searches[i].itemDescription}",
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  ),
                  title: Text(" ${searches[i].itemName}"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ViewObject(url: "${searches[i].itemLocation}")));
                  },
                );
              },
            ),
          ))
    ]);
  }
  Future<http.Response> fetchData() async {
    final url = Uri.https('virotour.com', '/search/$searchTerm');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load the tours, please try again");
    }
  }

}