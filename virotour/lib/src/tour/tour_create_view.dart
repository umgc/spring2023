import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:virotour/src/helpers/ip_handler.dart';

int hotspotCounter = 0;

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
  List<Hotspot> transitionalHotspots = [];

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

  Future<Uint8List?> networkImageToInts(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: transitionalHotspots.map((hotspot) {
                        return Card(
                          child: ListTile(
                            title: Text(hotspot.fileNames),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              child: const Icon(Icons.delete),
                              onPressed: () {
                                transitionalHotspots.removeWhere((element) {
                                  return element.fileNames == hotspot.fileNames;
                                });
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    Map<Uint8List, File> tmpImages = HashMap();

                    List<XFile> images = await _picker.pickMultiImage();
                    if (images.length != 0) {
                      for (XFile xf in images) {
                        print(xf.path);
                        if (kIsWeb) {
                          print("Running application on web");
                          Uint8List? imgBytes =
                              await networkImageToInts(xf.path);
                          tmpImages.addAll({imgBytes!: File(xf.path)});
                        } else {
                          print("Running application on mobile");
                          Uint8List? imgBytes = await xf.readAsBytes();
                          tmpImages.addAll({imgBytes!: File(xf.path)});
                        }
                      }
                      transitionalHotspots.add(Hotspot(tmpImages));
                    }

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
                      final urlAddTourBody = {
                        'name': _nameController.text,
                        'description': _descriptionController.text,
                      };

                      final Map<String, String> headers = {
                        'Content-Type': 'application/json'
                      };
                      final Object body = json.encode(urlAddTourBody);
                      final Map<String, String> options = {
                        'headers': headers.toString(),
                        'body': body.toString()
                      };

                      final http.Response response =
                          await IPHandler().post('/api/tour/add', options);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        // Send location data for each transitional hotspot

                        for (final Hotspot location in transitionalHotspots) {
                          final MultipartRequest locationRequest =
                              await IPHandler().requestMultipart(
                            '/api/tour/add/images/${_nameController.text}',
                          ) as http.MultipartRequest;

                          final headers = {
                            "Content-type": "multipart/form-data"
                          };

                          location.getImages().forEach((bytes, file) {
                            locationRequest.files.add(
                                http.MultipartFile.fromBytes("image", bytes,
                                    filename: basename(file.path)));
                          });
                          locationRequest.headers.addAll(headers);

                          final locationResponse = await locationRequest.send();

                          if (locationResponse.statusCode != 200) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Failed to create location'),
                                content: Text(
                                    'Status code: ${locationResponse.statusCode}'),
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

                        final http.Response tourResponse =
                            await IPHandler().get(
                          '/api/compute-tour/${_nameController.text}',
                        );
                        if (tourResponse.statusCode == 200) {
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
                                  'Status code: ${tourResponse.statusCode}'),
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
  String fileNames = "";
  Map<Uint8List, File> images = HashMap();

  Hotspot(this.images) {
    images.forEach((k, v) => fileNames += "${basename(v.path)}\n");
  }

  Map<Uint8List, File> getImages() {
    return images;
  }
}
