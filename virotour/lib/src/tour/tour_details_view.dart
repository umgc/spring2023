import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class TourDetailsView extends StatefulWidget {
  const TourDetailsView({Key? key}) : super(key: key);
  static const routeName = '/tour';

  @override
  _TourDetailsViewState createState() => _TourDetailsViewState();
}

class _TourDetailsViewState extends State<TourDetailsView> {
  late String _panoramaUrl;
  late String _panoramaUrl2;

  @override
  void initState() {
    super.initState();
    _panoramaUrl = 'https://i.imgur.com/O9CBhdM.jpg';
    _panoramaUrl2 = 'https://i.imgur.com/yrhSmSh.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour Details / Tour Name'),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            if (_panoramaUrl == _panoramaUrl2) {
              _panoramaUrl = 'https://i.imgur.com/O9CBhdM.jpg';
            } else {
              _panoramaUrl = _panoramaUrl2;
            }
          });
        },
        child: Panorama(
          sensitivity: 2.0,
          child: Image.network(_panoramaUrl),
          hotspots: _panoramaUrl == _panoramaUrl2
              ? [
                  Hotspot(
                    latitude: -190,
                    longitude: -60,
                    width: 60.0,
                    height: 60.0,
                    widget: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 80, 80),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: () {
                          setState(() {
                            _panoramaUrl = 'https://i.imgur.com/O9CBhdM.jpg';
                          });
                        },
                      ),
                    ),
                  ),
                ]
              : [
                  Hotspot(
                    latitude: -170.0,
                    longitude: 90.0,
                    width: 60.0,
                    height: 60.0,
                    widget: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 80, 80),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: () {
                          setState(() {
                            _panoramaUrl = _panoramaUrl2;
                          });
                        },
                      ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
