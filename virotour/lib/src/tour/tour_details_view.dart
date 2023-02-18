import 'dart:math';

import 'package:flutter/material.dart';
import 'package:virotour/src/helpers/helpers.dart';
import 'package:webviewx/webviewx.dart';

/// Displays detailed information about a Tour.
class TourDetailsView extends StatefulWidget {
  const TourDetailsView({super.key});
  static const routeName = '/tour';

  @override
  State<TourDetailsView> createState() => _TourDetailsViewState();
}

class _TourDetailsViewState extends State<TourDetailsView> {
  late WebViewXController webviewController;

  Size get screenSize => MediaQuery.of(context).size;

  // @override
  // void dispose() {
  //   webviewController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour Details / Tour Name'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              buildSpace(direction: Axis.vertical, amount: 10.0, flex: false),
              Container(
                padding: const EdgeInsets.only(bottom: 20.0),
              ),
              buildSpace(direction: Axis.vertical, amount: 10.0, flex: false),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.2),
                ),
                child: _buildWebViewX(),
              ),
              Expanded(
                child: Scrollbar(
                  isAlwaysShown: true,
                  child: SizedBox(
                    width: min(screenSize.width * 0.8, 512),
                    child: ListView(
                      children: _buildButtons(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebViewX() {
    return WebViewX(
      key: const ValueKey('webviewx'),
      initialSourceType: SourceType.html,
      height: screenSize.height / 2,
      width: min(screenSize.width * 0.8, 1024),
      onWebViewCreated: (controller) => webviewController = controller,
      onPageStarted: (src) =>
          debugPrint('A new page has started loading: $src\n'),
      onPageFinished: (src) =>
          debugPrint('The page has finished loading: $src\n'),
      jsContent: const {
        EmbeddedJsContent(
          js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
        ),
        EmbeddedJsContent(
          webJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
          mobileJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
        ),
      },
      dartCallBacks: {
        DartCallback(
          name: 'TestDartCallback',
          callBack: (msg) => showSnackBar(msg.toString(), context),
        )
      },
      webSpecificParams: const WebSpecificParams(
        printDebugInfo: true,
      ),
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
      navigationDelegate: (navigation) {
        debugPrint(navigation.content.sourceType.toString());
        return NavigationDecision.navigate;
      },
    );
  }

  void _setUrl() {
    webviewController.loadContent(
      'https://cdn.pannellum.org/2.5/pannellum.htm#panorama=https%3A//i.imgur.com/O9CBhdM.jpg&autoLoad=true',
      SourceType.url,
    );
  }

  void _setUrlBypass() {
    webviewController.loadContent(
      'https://news.ycombinator.com/',
      SourceType.urlBypass,
    );
  }

  Widget buildSpace({
    Axis direction = Axis.horizontal,
    double amount = 0.2,
    bool flex = true,
  }) {
    return flex
        ? Flexible(
            child: FractionallySizedBox(
              widthFactor: direction == Axis.horizontal ? amount : null,
              heightFactor: direction == Axis.vertical ? amount : null,
            ),
          )
        : SizedBox(
            width: direction == Axis.horizontal ? amount : null,
            height: direction == Axis.vertical ? amount : null,
          );
  }

  List<Widget> _buildButtons() {
    return [
      buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
      createButton(
        text: 'Pannellum Tour',
        onTap: _setUrl,
      ),
      buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
      createButton(
        text: 'https://news.ycombinator.com/',
        onTap: _setUrlBypass,
      ),
    ];
  }
}
