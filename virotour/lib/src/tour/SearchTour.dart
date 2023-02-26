import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchTour extends StatelessWidget {
  const SearchTour({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const viroTitle = 'Search Tours';
    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(
          title: const Text(viroTitle),
        ),
        body:const SearchScreen(),
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
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<StatefulWidget> createState() => _SearchTour();


}
class _SearchTour extends State<SearchScreen> {
  _SearchTour();

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
          child: TextField(controller: _searchTerm,decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                borderSide: BorderSide(color: Colors.white),
              ),
              labelText: 'Enter a search term',prefixIcon: Padding(
            padding: EdgeInsets.only(top: 0), // add padding to adjust icon
            child: Icon(Icons.search),
          )

          ),onSubmitted: (value) { Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TourList()));},),
        ),

      ],
    );

  }


  Future<http.Response> fetchData() async {
    String searchTerm = _searchTerm.text;
    final  url = Uri.https('virotour.com','tours/search/$searchTerm');

    final response = await http.get(url);
    if(response.statusCode==200){
      return json.decode(response.body);
    }else{
      throw Exception ("Failed to load the tours, please try again");
    }

  }




}
class TourList extends StatelessWidget {
  TourList({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: 4,

      padding: const EdgeInsets.all(4.0),
      childAspectRatio: 6.0 / 4.0,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children:  <Widget>[
        Material(
          child: InkWell(
            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SearchTour()));},

            child: Image.network('https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.PzQkGTYFc_Ipn0iMSl7bTwHaE7%26pid%3DApi&f=1&ipt=ee6edbaaf1bd9bf3b0ed33f3f711b4e6ef17de6cd992edbe6781b75792337533&ipo=images',
                fit: BoxFit.cover),

          ),
        ),
        Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.BeFek8UkX_F0-7VsE_klsgHaFj%26pid%3DApi&f=1&ipt=9d80aa4d1808e0326a53c2e14470a8e8011eeafda6fe8ca64617cb7b3bbe03cd&ipo=images", fit: BoxFit.cover),
        Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.ainonline.com%2Fsites%2Fdefault%2Ffiles%2Fstyles%2Fain30_fullwidth_large_2x%2Fpublic%2Fuploads%2F2015%2F10%2Fweb15.jpg%3Fitok%3D9FaLQNDg%26timestamp%3D1445024614&f=1&nofb=1&ipt=3295aede2925d4a9a473a91f3abc15e9331f28c0378be048ab77ffd2064f0bf7&ipo=images",fit:BoxFit.cover),
        Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.aLeWfLdhXpV31GW_suP0vgEsDS%26pid%3DApi&f=1&ipt=6b14f9c2a7f5fe9b285423f74ad0b8dc3e7a1b1db9581284d485d774191cf450&ipo=images",fit:BoxFit.cover),

        Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.1zIltfoMJLr5zmNoE7afOAHaEK%26pid%3DApi&f=1&ipt=125267740f8eecb9b92b714e0c4a3b748bb239c7aa295406f631afc28c2e94f2&ipo=images",fit:BoxFit.cover),

        Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.l3bkVDbQYUnBd0ZquBAVuQHaEY%26pid%3DApi&f=1&ipt=df79f6b50baf8bfc35a0b50c55efb989cebf731c3e7f8e7220c7e07e31321fbc&ipo=images",fit:BoxFit.cover),
        Image.network("http://generalaviationnews.com/wp-content/uploads/2015/04/Warbirds-UdvarHazy-Photo-by-Dane-Penland-National-Air-and-Space-Museum.jpg",fit:BoxFit.cover),
        Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.JXUTZ7A9xaJX8yGimFC2RwHaDd%26pid%3DApi&f=1&ipt=564409ab64541f4b428ee9c8f41c8f065bbc865640e8174dd92b8d36701b3aa5&ipo=images",fit:BoxFit.cover),

        Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.-_KKH39p_iHgXgytZF5L2AHaFm%26pid%3DApi&f=1&ipt=04ef1a8de9575998de137cab02422f80e05f958ea1be312775f50cb785659109&ipo=images",fit:BoxFit.cover),
        Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.UlpTkzTXCEKmoA9TaObwYgHaEr%26pid%3DApi&f=1&ipt=610c55e7e27877adbf3047336675e7d53619353138c1caac14eb208f0c0bc715&ipo=images",fit:BoxFit.cover),
        Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.-Zgo3inZkn5XBZUlTomPOwHaFD%26pid%3DApi&f=1&ipt=9add4963b045b1c50e9c46cdc2d301882aa2f2995601b39127938c41014d887c&ipo=images",fit:BoxFit.cover),
        Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.A7LJzJob4EcJ--091PF_nQHaEK%26pid%3DApi&f=1&ipt=8bc963dcbc67d0e78724292eadcb2a7e181d45dcc5e5feeff83936c706834807&ipo=images",fit:BoxFit.cover),
        Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.lAQVE7K4quUyDW1DSzajmAHaFj%26pid%3DApi&f=1&ipt=eaa44f5d4ec9adc268f9198a990f1f1068db9880c768fbb3121856a9e166d696&ipo=images",fit:BoxFit.cover),

      ],
    );

  }
  final  url = Uri.https('google.com', '?q=tour/search/WWI');
  Future<http.Response> fetchData() async {
    print(url.toString());
    final response = await http.get(url);
    if(response.statusCode==200){
      return json.decode(response.body);
    }else{
      throw Exception ("Failed to load the tours, please try again");
    }

  }


}
