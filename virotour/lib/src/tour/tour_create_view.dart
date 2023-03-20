import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

int hotspotCounter = 0;

class TourCreateView extends StatefulWidget {
  static const routeName = '/create_tour';

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
                    final Map<Uint8List, File> tmpImages = HashMap();

                    final List<XFile> images = await _picker.pickMultiImage();
                    if (images.isNotEmpty) {
                      for (final XFile xf in images) {
                        if (kIsWeb) {
                          final Uint8List? imgBytes =
                              await networkImageToInts(xf.path);
                          tmpImages.addAll({imgBytes!: File(xf.path)});
                        } else {
                          final Uint8List imgBytes = await xf.readAsBytes();
                          tmpImages.addAll({imgBytes: File(xf.path)});
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
                  // Cancel button
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
                  // Save button
                  ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text == "" ||
                          _descriptionController.text == "") {
                        _showRequiredFields(context);
                        return;
                      }
                      debugPrint('Try to send request!');
                      // To avoid the browser or the simulator throw an error
                      // after trying to get the response from the server, we keep this part empty.
                      // TODO: Make real API call to the endpoint and handle errors if any.

                      // By default, after successfully posting the tour, redirect users to the list of tours
                      Navigator.pushNamed(context, '/');
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
