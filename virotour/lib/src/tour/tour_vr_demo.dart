import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class TourVrDetailsView extends StatefulWidget {
  const TourVrDetailsView({super.key});

  static const routeName = '/vr';

  @override
  State<TourVrDetailsView> createState() => _TourVrDetailsViewState();
}

class _TourVrDetailsViewState extends State<TourVrDetailsView> {
  late WebViewXController webviewController;

  Future<String> getTourHtml() async {
    return await rootBundle.loadString('assets/index.html');
  }

  static const tourHtml = """
<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">
  <title>CodePen - Image Panorama - Viewer API</title>
  <style>
html, body {
  width: 100%;
  height: 100%;
  overflow: hidden;
  margin: 0;
}
#container {
  width: 100%;
  height: 100%;
}
.button {
  position: absolute;
  left: 10px;
  padding: 1rem;
}
#modeButton {
  top: 1rem;
}
.desc-container {
  max-width: 400px;
  max-height: 400px;
  min-width: 200px;
  min-height: 250px;
  background: #fff;
  color: #000;
  border-radius: 3px;
  overflow: auto;
  -webkit-overflow-scrolling: touch;
}
.desc-container > iframe {
  border: none;
  width:100%;
}
</style>
</head>
<body>
<!-- partial:index.partial.html -->
<div id="container"></div>
<button id="modeButton" class="button">Toggle VR </button>
<div id = "boxes"></div>
<!-- partial -->
  <script src='https://pchen66.github.io/js/three/three.min.js'></script>
<script src='https://rawgit.com/pchen66/panolens.js/dev/build/panolens.min.js'></script><script>
var panorama, viewer, container, infospot, controlButton, modeButton, videoButton;
var modeIndex = 0;
const tours =[];
var input = '{ "data": { "model": { "locations": [{ "id": "location_1", "position": { "x": 0, "y": 0, "z": 0 }, "images": { "filters": { "glow": { "strength": 1, "radius": 25 } }, "original": { "source": ["img_lower_left.png", "img_lower_middle.png", "img_lower_right.png", "img_upper_left.png", "img_upper_middle.png", "img_upper_right.png"] }, "panoramic": { "source": ["img_panoramic.png"] }, "blurred": { "source": ["https://i.imgur.com/igGyWbz.jpg"] } }, "transitional_hotspots": [{ "main_hall": { "x": 3500, "y": 0, "z": 0 }}], "informational_hotspots": [{ "position": { "x": -117, "y": -58, "z": -5000 }, "content": "<div>Just some boring text here</div>" }], "text": [{ "position": { "x": 3062, "y": 234, "z": -5000 }, "content": "This way to the main exhibit" }] },{ "id": "main_hall", "position": { "x": 0, "y": 0, "z": 0 }, "images": { "filters": { "glow": { "strength": 1, "radius": 25 } }, "original": { "source": ["img_lower_left.png", "img_lower_middle.png", "img_lower_right.png", "img_upper_left.png", "img_upper_middle.png", "img_upper_right.png"] }, "panoramic": { "source": ["img_panoramic.png"] }, "blurred": { "source": ["https://i.imgur.com/O9CBhdM.jpg"] } }, "transitional_hotspots": [{ "location_1": { "x": -3500, "y": -20, "z": 20 }}], "informational_hotspots": [ { "position": { "x": -656, "y": -891, "z": -5000 }, "content": "<div>more content</div>" } ], "text": [{ "position": { "x": -46779, "y": -937, "z": -5000 }, "content": "This painting depicts the struggles of…" }, { "position": { "x": 4821, "y": 207, "z": 5000 }, "content": "This is a b56" } ] }]}}}'
const obj = JSON.parse(input);
//populate the images into panoramas
for(var i =0; i<obj.data.model.locations.length; i++){
     tours.push(new PANOLENS.ImagePanorama(obj.data.model.locations[i].images.blurred.source[0]));
}
//populate the links among panoramas
for(var i =0; i<obj.data.model.locations.length; i++){
  for(var hotInd in obj.data.model.locations[i].transitional_hotspots){
    for(var id in obj.data.model.locations[i].transitional_hotspots[hotInd]){
      //console.log(id);
      var id_index =0;
      while(!(obj.data.model.locations[id_index].id === id)){
        id_index++; 
      }
      var coords = obj.data.model.locations[i].transitional_hotspots[hotInd][id]
      //console.log(coords);
      var x = coords['x'];
      var y = coords['y'];
      var z = coords['z'];
      tours[i].link(tours[id_index],  new THREE.Vector3(x, y, z));
    }
  }
}
//converts info into html element
var stringToHTML = function (str) {
	// Otherwise, fallback to old-school method
	var dom = document.createElement('div');
	dom.innerHTML = str;
	return dom;
};
//process informational hotspots
for(var i =0; i<obj.data.model.locations.length; i++){
  for(var hotInd in obj.data.model.locations[i].informational_hotspots){
    var hotspot = obj.data.model.locations[i].informational_hotspots[hotInd]
    //console.log(hotspot.position);
      var x = hotspot.position['x'];
      var y = hotspot.position['y'];
      var z = hotspot.position['z'];
    
    infospot = new PANOLENS.Infospot( 350, PANOLENS.DataImage.Info );
    infospot.position.set( x, y, z);
    var desc_container = document.createElement("div");
    var boxes = document.getElementById("boxes");
    desc_container.innerHTML = hotspot.content;
    desc_container.classList.add('desc-container');
    console.log(hotspot.content);
    boxes.appendChild(desc_container);
    infospot.addHoverElement(desc_container);
    tours[i].add(infospot);
  }
}
//maybe we need this
    // <div class="desc-container" id="id1" style="display:none">
    //   <div class="text">we be hoverin</div>
    // </div>
//process text-based hotspots
for(var i =0; i<obj.data.model.locations.length; i++){
  for(var hotInd in obj.data.model.locations[i].text){
    var hotspot = obj.data.model.locations[i].text[hotInd];
      var x = hotspot.position['x'];
      var y = hotspot.position['y'];
      var z = hotspot.position['z'];
    
    infospot = new PANOLENS.Infospot( 350, PANOLENS.DataImage.Info );
    infospot.position.set( x, y, z);
    infospot.addHoverText(hotspot.content);
    tours[i].add(infospot);
  }
}
container = document.querySelector( '#container' );
modeButton = document.querySelector( '#modeButton' );
//create the viewer
viewer = new PANOLENS.Viewer( { 
  container: container, 
  autoHideInfospot: false,
  output: 'console'
} );
//add tours
for(var i=0; i<tours.length; i++){
  viewer.add(tours[i]);
}
//vr mode toggle
modeButton.addEventListener( 'click', function(){
  
  modeIndex = modeIndex >= 2 ? 0 : modeIndex + 1;
  
  switch ( modeIndex ) {
      
    case 0: viewer.disableEffect(); break;
    case 1: viewer.enableEffect( PANOLENS.MODES.CARDBOARD ); break;
    case 2: viewer.enableEffect( PANOLENS.MODES.STEREO ); break;
    default: break;
      
  }
} );
//for debugging
container.addEventListener( 'click', function(){
  viewer.outputPosition(); 
  });
</script>
</body>
</html>
""";
  late bool loaded;

  @override
  void initState() {
    super.initState();
    loaded = false;
    // Get the order
  }

  void setLoaded(bool input) {
    debugPrint('Page finished loading');
    setState(() {
      loaded = input;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final padding = MediaQuery.of(context).padding;
    final safeHeight = height - padding.top - padding.bottom;
    final safeWidth = width - padding.left - padding.right;

    // final arguments =
    // ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final tourId = arguments['id'] as String;
    // final tourName = arguments['name'] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text("Vr Demo"),
      ),
      body: FutureBuilder<String>(
        future: getTourHtml(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return
              Visibility(
                visible: loaded,
                maintainState: true,
                child: WebViewX(
                  height: safeHeight,
                  width: safeWidth,
                  initialContent: snapshot.data!,
                  initialSourceType: SourceType.html,
                  onPageStarted: (url) {
                    debugPrint('Page started loading');
                  },
                  onPageFinished: (url){
                    debugPrint(snapshot.data);
                    setLoaded(true);
                  },
                  onWebResourceError: (error) {
                    debugPrint('WebViewX error: ${error.description}');
                  }, // Set the background color
                ),
              );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

