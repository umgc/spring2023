import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  DateTime selectedDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  List<Hotspot> transitional_hotspots = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
              TextFormField(
                controller: _locationController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Location',
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Date: ${"${selectedDate.toLocal()}".split(' ')[0]}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Select date'),
                      ),
                    ],
                  ),
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
                            title: Text(hotspot.name),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent),
                              child: Icon(Icons.delete),
                              onPressed: () {
                                transitional_hotspots.removeWhere((element) {
                                  return element.name == hotspot.name;
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
                    transitional_hotspots
                        .add(new Hotspot(await _picker.pickMultiImage()));
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
                      // Creation of the tour object
                      final url_add_tour = 'http://127.0.0.1:8081/api/tour/add';

                      /* TODO: Uncomment this in prod
                      final response = await http.post(
                        Uri.parse(url),
                        headers: {'Content-Type': 'application/json'}
                      );
                      
                      if (response.statusCode == 200) {
                        // Send location data for each transitional hotspot
                        for (location in transitional_hotspots) {
                          final location_response = await http.post(
                            Uri.parse("http://127.0.0.1:8081/api/tour/add/images/${response.name}"),
                            headers: {'Content-type': 'multipart/form-data'},
                            body: {
                              images: location.images
                            }
                          )
                          if (location_response.statusCode != 200) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Failed to create ${location.name}'),
                                content:
                                Text('Status code: ${location_response.statusCode}'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                          }
                        }
                      // Compute tour
                      final tour_response = await http.get(
                        Uri.parse("http://127.0.0.1:8081/api/compute-tour/${response.name}")
                      )
                      if (tour_response.statusCode == 200){
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Done'),
                            content: const Text("Successfully created tour!")
                            actions: [
                              TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                      }
                      else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Failed to compute tour'),
                            content:
                            Text('Status code: ${tour_response.statusCode}'),
                            actions: [
                              TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
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
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                      */
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
  String name = "";
  List<XFile>? images = [];

  Hotspot(this.images) {
    this.name = "location_" + hotspot_counter.toString();
    hotspot_counter++;
  }
}
