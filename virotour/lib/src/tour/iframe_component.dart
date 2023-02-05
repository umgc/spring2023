//ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() => runApp(IFrameComponent());

class IFrameComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        body: Center(
          child: Container(
            width: screenWidth,
            // height: 800,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface, width: 1.0),
            ),
            child: const IframeView(
                source:
                    "https://firebasestorage.googleapis.com/v0/b/virotour-19daa.appspot.com/o/users%2Fhang_wang%2F1.jpg?alt=media&token=0b26a6d6-a281-4c21-9ff1-ea7f9088386f"),
          ),
        ),
      ),
    );
  }
}

class IframeView extends StatefulWidget {
  final String source;

  const IframeView({Key? key, required this.source}) : super(key: key);

  @override
  _IframeViewState createState() => _IframeViewState();
}

class _IframeViewState extends State<IframeView> {
  // Widget _iframeWidget;
  final IFrameElement _iframeElement = IFrameElement();

  @override
  void initState() {
    super.initState();
    _iframeElement.src = widget.source;
    _iframeElement.style.border = 'none';

    //ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
  }
}
