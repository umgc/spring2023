import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:virotour/src/tour/tour.dart';

int hotspot_counter = 0;

class TourCreateView extends StatefulWidget {
  static const routeName = '/tour_create';

  const TourCreateView({super.key});

  @override
  _TourCreateViewState createState() => _TourCreateViewState();
}

class _TourCreateViewState extends State<TourCreateView> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final ImagePicker _picker = ImagePicker();
  List<Hotspot> transitional_hotspots = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showRequiredFields(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Name and Description are required fields.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Tour'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16.0),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: transitional_hotspots.map((hotspot) {
                      return Container(
                        child: Card(
                          child: ListTile(
                            title: Text(hotspot.file_names),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent),
                              child: Icon(Icons.delete),
                              onPressed: () {
                                transitional_hotspots.removeWhere((element) {
                                  return element.file_names ==
                                      hotspot.file_names;
                                });
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    Map<Image, File> tmpImages = HashMap();
                    final images = await _picker.pickMultiImage();
                    for (XFile xf in images) {
                      if (kIsWeb) {
                        tmpImages
                            .addAll({Image.network(xf.path): File(xf.path)});
                      } else {
                        tmpImages
                            .addAll({Image.file(File(xf.path)): File(xf.path)});
                      }
                    }
                    transitional_hotspots.add(new Hotspot(tmpImages));
                    setState(() {});
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(Icons.image),
                      Text(' Select Images'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text == "" ||
                          _descriptionController.text == "") {
                        _showRequiredFields(context);
                        return;
                      }
                      // Creation of the tour object
                      final url_add_tour =
                          'http://192.168.50.43:8081/api/tour/add';
                      final url_add_tour_body = {
                        'name': _nameController.text,
                        'description': _descriptionController.text,
                      };

                      final response = await http.post(
                        Uri.parse(url_add_tour),
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode(url_add_tour_body),
                      );
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        // Send location data for each transitional hotspot

                        for (Hotspot location in transitional_hotspots) {
                          var location_request = http.MultipartRequest(
                              'POST',
                              Uri.parse(
                                  "http://192.168.50.43:8081/api/tour/add/images/${_nameController.text}"));

                          location.getImages().forEach((k, v) async {
                            location_request.files.add(
                                http.MultipartFile.fromBytes(
                                    "picture", v.readAsBytesSync(),
                                    filename: basename(v.path)));
                          });

                          /*
                          for (String s in location.getAllInfo()) {
                            location_request.files.add(
                              http.MultipartFile.fromBytes(
                                "picture",
                                s.readAsBytesSync(),
                                filename: s.split("/").last
                              )
                            );
                          }
                          */
                          var location_response = await location_request.send();

                          if (location_response.statusCode != 200) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Failed to create location'),
                                content: Text(
                                    'Status code: ${location_response.statusCode}'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context)
                                        .popUntil((route) => route.isFirst),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                        // Compute tour
                        final tour_response = await http.get(Uri.parse(
                            "http://192.168.50.43:8081/api/compute-tour/${_nameController.text}"));
                        if (tour_response.statusCode == 200) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Done'),
                              content: const Text("Successfully created tour!"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .popUntil((route) => route.isFirst),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Failed to compute tour'),
                              content: Text(
                                  'Status code: ${tour_response.statusCode}'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .popUntil((route) => route.isFirst),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Failed to create tour'),
                            content:
                                Text('Status code: ${response.statusCode}'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .popUntil((route) => route.isFirst),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Hotspot {
  String file_names = "";
  Map<Image, File> images = HashMap();

  Hotspot(Map<Image, File> images) {
    this.images = images;
    images.forEach((k, v) => this.file_names += basename(v.path) + "\n");
  }

  Map<Image, File> getImages() {
    return this.images;
  }
}
