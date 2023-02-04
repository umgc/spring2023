import 'package:flutter/material.dart';
import 'package:virotour/src/tour/iframe_tester.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Displays detailed information about a Tour.
class TourDetailsView extends StatefulWidget {
  const TourDetailsView({super.key});
  static const routeName = '/tour';

  @override
  State<TourDetailsView> createState() => _TourDetailsViewState();
}

class _TourDetailsViewState extends State<TourDetailsView> {
  // late final WebViewController controller;

  // @override
  // void initState() {
  //   super.initState();
  //   controller = WebViewController()
  //     ..loadRequest(
  //       Uri.parse('https://flutter.dev'),
  //     );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour Details'),
      ),
      // body: const Center(
      //   child: Text('More Information Here'),
      // body: WebViewWidget(
      //   controller: controller,
      // ),
      // body: Image.network('https://picsum.photos/250?image=9'),
      body: IFrameTesterApp(),
    );
  }
}
