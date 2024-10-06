import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:async';
import '../utils.dart';
import 'map_page.dart';
import 'game_summary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:geo_location_app/DBComponents/loc_model.dart';


class GamePage extends StatefulWidget {
  final String selectedDifficulty;
  final String selectedLength;
  final String selectedLocation;

  // Constructor to initialize GamePage with selected difficulty, length, and location
  const GamePage({
    super.key,
    required this.selectedDifficulty,
    required this.selectedLength,
    required this.selectedLocation,
  });

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  // Variables to store game-related data
  late List<Map<String, dynamic>> selectedLocations = [];
  late List<Map<String, dynamic>> savedLocations = [];
  late Timer timer;
  int remainingTimeInSeconds = 0;
  int hintUses = 0;

  int locationIndex = 0;
  bool isSnackBarVisible = false;
  Completer<void> _snackBarCompleter = Completer<void>();

  bool isSubmitButtonEnabled = false;
  final _model = LocModel();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  // Method to start the game
  void startGame() {
    // Fetch and shuffle selected locations
    getLocations().then((locations) {
      setState(() {
        selectedLocations = locations;
      });

      // Set initial timer based on difficulty and number of locations
      int initialTimePerImage = getInitialTimePerImage();
      remainingTimeInSeconds = initialTimePerImage;
      hintUses = getNumberOfGuesses();

      // Start a timer to update remaining time
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (remainingTimeInSeconds > 0) {
          setState(() {
            remainingTimeInSeconds--;
          });

          // Show a notification when 10 seconds remaining
          if (remainingTimeInSeconds == 60) {
            Utils.showNotification('Time is running out!', 'Only 60 seconds left.');
          }
        } else {
          // if this, or any statement like this gets removed, things go wrong
          if (selectedLocations != null) {
            _navigateToNextImageOrSummary();
          }
        }
      });
    });
  }

  // Handle back button press
  Future<bool> _onBackPressed() {
    Future<dynamic> toReturn = showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to quit?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel button
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF7AA095)), // Set text color
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD94148), // Set button background color
              foregroundColor: Colors.white,
            ),
            child: const Text('Quit'),
          ),
        ],
      ),
    );
    if (toReturn == true) {
      return Future(() => false);
    }
    return Future(() => true);
  }

  // Fetch locations based on the selected location
  Future<List<Map<String, dynamic>>> getLocations() async {
    // location names are passed as: 'Ontario Tech', 'Durham College', 'Local Storage'
    late List<Map<String, dynamic>> allLocations;
    if (widget.selectedLocation=="Local Storage"){
      allLocations = await _model.getAllLocsAsMap();
    } else {
      String collectionName = widget.selectedLocation == 'Ontario Tech'
          ? 'Locations'
          : 'LocationsDC';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .get();

      allLocations = querySnapshot.docs.map((
          DocumentSnapshot doc) {
        // print(doc['coordinates']);
        return {
          'coordinates': doc['coordinates'],
          'image': doc['image'],
        };
      }).toList();
    }

    int numberOfLocations = 5;
    if (widget.selectedLength == 'Medium') {
      numberOfLocations = 10;
    } else if (widget.selectedLength == 'Long') {
      numberOfLocations = 15;
    }

    if (allLocations.length > numberOfLocations) {
      allLocations.shuffle();
      return allLocations.sublist(0, numberOfLocations);
    } else {
      return allLocations;
    }
  }

  // Get the initial time allowed per image based on difficulty
  int getInitialTimePerImage() {
    if (widget.selectedDifficulty == 'Easy') {
      return 60 * 20; // 20 minutes per image
    } else if (widget.selectedDifficulty == 'Medium') {
      return 60 * 10; // 10 minutes per image
    } else {
      return 60 * 5; // 5 minutes per image
    }
  }

  // Get the number of allowed guesses based on difficulty
  int getNumberOfGuesses() {
    if (widget.selectedDifficulty == 'Easy') {
      return 5;
    } else if (widget.selectedDifficulty == 'Medium') {
      return 3;
    } else {
      return 1;
    }
  }

  // Show a snack bar with the user's current location
  Future<void> showCurrentLocationSnackBar() async {
    try {
      LocationData locationData = await _getUserLocation();
      // print(locationData.latitude);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You are ${Utils.calculateDistance([locationData.latitude, locationData.longitude], selectedLocations[locationIndex]['coordinates'])} meters from the location',
          ),
          backgroundColor: const Color(0xFF7AA095),
        ),
      ).closed.then((_) {
        setState(() {
          isSnackBarVisible = false;
        });
        _snackBarCompleter.complete();
      });
    } catch (e) {
      // print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error getting user location.',
          ),
          backgroundColor: Color(0xFF7AA095),
        ),
      ).closed.then((_) {
        setState(() {
          isSnackBarVisible = false;
        });
        _snackBarCompleter.complete();
      });
    }
  }

  // Get the user's current location
  Future<LocationData> _getUserLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    // Check and enable location services
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }
    }

    // Check and request location permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw 'Location permission not granted.';
      }
    }

    // Get the user's location
    locationData = await location.getLocation();
    return locationData;
  }

  // Navigate to the next image or summary screen
  void _navigateToNextImageOrSummary() async {
    isSubmitButtonEnabled = false;
    timer.cancel();
    if (!isSnackBarVisible) {
      setState(() {
        isSnackBarVisible = true;
      });

      showCurrentLocationSnackBar();

      await _snackBarCompleter.future;

      // see above. this is necessary
      if (selectedLocations != null) {
        saveUserGuessedLocation();

        if (locationIndex == (selectedLocations.length - 1)) {
          if (savedLocations.isNotEmpty) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GameSummary(
                savedLocations: savedLocations,
                selectedLocations: selectedLocations,
              ),
            ));
          }
          _snackBarCompleter = Completer<void>();
        } else {
          timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
            if (remainingTimeInSeconds > 0) {
              setState(() {
                remainingTimeInSeconds--;
              });
              if (remainingTimeInSeconds == 60) {
                Utils.showNotification('Time is running out!', 'Only 60 seconds left.');
              }
            } else {
              if (selectedLocations != null) {
                _navigateToNextImageOrSummary();
              }
            }
          });
          _snackBarCompleter = Completer<void>();
          setState(() {
            locationIndex = (locationIndex + 1) % selectedLocations.length;
            remainingTimeInSeconds = getInitialTimePerImage();
          });
        }
      }
    }
  }

  // Save the user's guessed location
  void saveUserGuessedLocation() async {
    try {
      LocationData locationData = await _getUserLocation();
      savedLocations.add({
        'guessed_coordinates': [locationData.latitude, locationData.longitude],
        'actual_coordinates': selectedLocations[locationIndex]['coordinates'],
      });
    } catch (e) {
      // Handle errors
    }
  }

  // Show a distance hint popup
  void showDistanceHint() async {
    try {
      LocationData locationData = await _getUserLocation();
      String distance = Utils.calculateDistance(
        [locationData.latitude, locationData.longitude],
        selectedLocations[locationIndex]['coordinates'],
      );

      // Show the DistanceHintPopup widget
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DistanceHintPopup(distance: distance, numGuesses: hintUses);
        },
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error getting distance hint.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSubmitButtonEnabled = selectedLocations != null &&
        selectedLocations.isNotEmpty &&
        remainingTimeInSeconds < getInitialTimePerImage() - 2;

    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Game Page', style: TextStyle(color: Color(0xFF40531B))),
          backgroundColor: const Color(0xFF7AA095),
          actions: [
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(
                      locationPoints: savedLocations
                          .map((location) => LatLng(
                          location['guessed_coordinates'][0],
                          location['guessed_coordinates'][1]))
                          .toList(),
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: () {
                if (hintUses > 0) {
                  showDistanceHint();
                  hintUses--;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No more hints available.',
                        style: TextStyle(color: Color(0xFF40531B)),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Location : ${locationIndex + 1} / ${selectedLocations?.length ?? 0}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF40531B)),
              ),
              const SizedBox(height: 10),
              Text(
                'Time Remaining: ${Utils.formatTime(remainingTimeInSeconds)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF40531B)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: selectedLocations != null && selectedLocations.isNotEmpty
                    ? Center(
                  child: Image.network(
                    selectedLocations[locationIndex]['image'],
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                )
                    : const CircularProgressIndicator(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSubmitButtonEnabled ? () => _navigateToNextImageOrSummary(): null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSubmitButtonEnabled ? const Color(0xFF7AA095) : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DistanceHintPopup extends StatelessWidget {
  final String distance;
  final int numGuesses;

  const DistanceHintPopup({super.key, required this.distance, required this.numGuesses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Distance Hint',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF40531B)),
              ),
              const SizedBox(height: 8.0),
              Text(
                'You are approximately $distance meters away from the location.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF40531B)),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF7AA095),
                  onPrimary: Colors.white,
                ),
                child: const Text('OK'),
              ),
              Text('You have $numGuesses more hint(s) remaining'),
            ],
          ),
        ),
      ),
    );
  }
}