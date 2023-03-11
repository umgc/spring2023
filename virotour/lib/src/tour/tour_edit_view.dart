// tour_edit_view.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virotour/src/tour/tour.dart';

class TourEditView extends StatefulWidget {
  static const routeName = '/tour_edit';

  final Tour tour;

  const TourEditView({required this.tour, super.key});

  @override
  _TourEditViewState createState() => _TourEditViewState();
}

class _TourEditViewState extends State<TourEditView> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tour.tourName);
    _descriptionController =
        TextEditingController(text: widget.tour.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tour'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      final url =
                          'http://192.168.1.217:8081/api/update/tour/${widget.tour.id}';
                      final body = {
                        'id': widget.tour.id,
                        'name': _nameController.text,
                        'description': _descriptionController.text,
                      };
                      final response = await http.post(
                        Uri.parse(url),
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode(body),
                      );
                      if (response.statusCode == 200) {
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Failed to update tour'),
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
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 16.0),
                  OutlinedButton(
                    onPressed: () async {
                      final confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                            'Are you sure you want to delete this tour?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirmDelete == true) {
                        final url =
                            'http://192.168.1.217:8081/api/delete/tour/${widget.tour.id}';
                        final response = await http.delete(Uri.parse(url));
                        if (response.statusCode == 200) {
                          Navigator.pop(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Failed to delete tour'),
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
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
