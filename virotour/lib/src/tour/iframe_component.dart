//ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() => runApp(IFrameComponent());

class IFrameComponent extends StatelessWidget {
  // <iframe width="600" height="400" allowfullscreen style="border-style:none;" src="https://cdn.pannellum.org/2.5/pannellum.htm#panorama=https%3A//i.imgur.com/O9CBhdM.jpg&autoLoad=true"></iframe>
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        body: Center(
          child: Container(
            width: screenWidth,
            // height: 400,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface, width: 1.0),
            ),
            child: const IframeView(
                source:
                    "https://cdn.pannellum.org/2.5/pannellum.htm#panorama=https%3A//i.imgur.com/O9CBhdM.jpg&autoLoad=true"),
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
    _iframeElement.allowFullscreen = true;

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
