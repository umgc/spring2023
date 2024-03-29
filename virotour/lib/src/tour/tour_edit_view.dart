import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virotour/src/helpers/ip_handler.dart';
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
                      // Will update if and when the API endpoint is ready
                      // final String body = {
                      //   'id': widget.tour.id,
                      //   'name': _nameController.text,
                      //   'description': _descriptionController.text,
                      // }.toString();

                      // final String headers =
                      //     {'Content-Type': 'application/json'}.toString();

                      // final Map<String, String> options = {
                      //   'headers': headers,
                      //   'body': body,
                      // };

                      // final http.Response response = await IPHandler()
                      //     .post('/api/update/tour/${widget.tour.id}', options);
                      // if (response.statusCode == 200) {
                      //   Navigator.pop(context);
                      // } else {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //       title: const Text('Failed to update tour'),
                      //       content:
                      //           Text('Status code: ${response.statusCode}'),
                      //       actions: [
                      //         TextButton(
                      //           onPressed: () => Navigator.pop(context),
                      //           child: const Text('OK'),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 16.0),
                  OutlinedButton(
                    onPressed: () async {
                      // Will update if and when the API endpoint is ready
                      // final confirmDelete = await showDialog<bool>(
                      //   context: context,
                      //   builder: (context) => AlertDialog(
                      //     title: const Text('Confirm Deletion'),
                      //     content: const Text(
                      //       'Are you sure you want to delete this tour?',
                      //     ),
                      //     actions: [
                      //       TextButton(
                      //         onPressed: () => Navigator.pop(context, false),
                      //         child: const Text('Cancel'),
                      //       ),
                      //       TextButton(
                      //         onPressed: () => Navigator.pop(context, true),
                      //         child: const Text('Delete'),
                      //       ),
                      //     ],
                      //   ),
                      // );
                      // if (confirmDelete == true) {
                      //   final http.Response response = await IPHandler()
                      //       .post('/api/tour/delete/${widget.tour.id}');

                      //   if (response.statusCode == 200) {
                      //     Navigator.pop(context);
                      //   } else {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) => AlertDialog(
                      //         title: const Text('Failed to delete tour'),
                      //         content:
                      //             Text('Status code: ${response.statusCode}'),
                      //         actions: [
                      //           TextButton(
                      //             onPressed: () => Navigator.pop(context),
                      //             child: const Text('OK'),
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   }
                      // }
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
