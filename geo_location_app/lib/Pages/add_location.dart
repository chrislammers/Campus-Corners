import 'package:flutter/material.dart';
import 'package:geo_location_app/DBComponents/geo_location.dart';
import 'package:geolocator/geolocator.dart';
import 'single_player_page.dart';
import '../DBComponents/loc_model.dart';

class takePhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create A Location'),
      ),
      body: Center(
        child: Text('Taking Photo Page'),
      ),
    );
  }
}

// this will allow the users to create a location. One way is with an image link,
//  and in the future, the user will be able to take a picture with their camera
// Lat/long should also have multiple options, (current location, manual entry, map selection)
class CreateLocation extends StatefulWidget {
  const CreateLocation({super.key});

  @override
  State<CreateLocation> createState() => _CreateLocationState();
}

class _CreateLocationState extends State<CreateLocation> {
  // this will build a Location object, and put it into either local storage or firebase

  // _difficulty to be removed
  late String _imgLink;
  late double _lat;
  late double _long;
  var _difficulty = "Medium";
  var _model = LocModel();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF7AA095),
      appBar: AppBar(

        title: Text('Create A Location'),
      ),
      body: Column(
        children: [
          Text("Link:"),
          TextField(
            decoration: InputDecoration(
              hintText: "imgur link etc.",
            ),
            onChanged: (value) {_imgLink = value;},
          ),
          Text("Coordinates:"),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Latitude",
            ),
            onChanged: (value) {_lat = double.parse(value);},
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Longitude",
            ),
            onChanged: (value) {_long = double.parse(value);},
          ),

          // don't need this row... difficulty is now based on time
          // before removing this, remove difficulty from database commands and stuff
          ElevatedButton(onPressed: _submitLoc,
              child: Text("Submit")),
          // when this is pressed, create a location
          // Text("Placeholder button ^")
        ],
      ),
    );
  }
  void _submitLoc() {
    int idHashed = hashDtoI(_lat, _long);
    print(idHashed);
    print(_lat);
    print(_long);
    GeoLocation loc = GeoLocation(id: idHashed, lat: _lat, long: _long, imgLink: _imgLink);
    _model.insertLoc(loc);
    Navigator.pop(context);
  }

  int hashDtoI(double v1, double v2) {
    // Convert doubles to integers by multiplying with a large constant and rounding
    int int1 = (v1 * 10000).round();
    int int2 = (v2 * 10000).round();
    // Combine the two integers into a single integer hash
    int hashedValue = int1 ^ int2;
    return hashedValue;
  }
}


/*
import 'package:camera/camera.dart';

class TakePhoto extends StatefulWidget {
  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
 CameraController _controller;
  List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Taking Photo Page'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Taking Photo Page'),
      ),
      body: CameraPreview(_controller),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final image = await _controller.takePicture();
            // Do something with the taken photo, like displaying it or saving it.
            print('Photo taken: ${image.path}');
          } catch (e) {
            print('Error taking photo: $e');
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}*/


