import 'package:flutter/material.dart';
import 'game_page.dart';
import 'package:geo_location_app/DBComponents/geo_location.dart';
import 'package:geo_location_app/DBComponents/loc_model.dart';

class SinglePlayerButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onPressed;

  const SinglePlayerButton({super.key,
    required this.text,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? const Color(0xFFAFBC88) : Colors.white,
        foregroundColor: selected ? Colors.white : Colors.black,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
class SinglePlayerPage extends StatefulWidget {
  const SinglePlayerPage({super.key});

  @override
  SinglePlayerPageState createState() => SinglePlayerPageState();
}

class SinglePlayerPageState extends State<SinglePlayerPage> {
  String selectedLength = 'Medium';
  String selectedDifficulty = 'Medium';
  String selectedLocation = 'Ontario Tech';

  final model = LocModel();
  List<String> _locations = ['Ontario Tech', 'Durham College'];
  bool isLocalReady = false;

  late List<GeoLocation> locList;

  String selectedValue = 'Choose option';

  _getList() async {
    locList = await model.getAllLocs();
    // print(locList.length);
    // 15 is threshold to play all levels
    if (locList.length>=15) {
      // print("PLEASE");
      _locations = ['Ontario Tech', 'Durham College', 'Local Storage'];
    }
  }

  void showCountdownPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(
            'Get Ready!',
            style: TextStyle(color: Colors.white),
          ),
          content: CountdownWidget(),
          backgroundColor: Color(0xFF7AA095), // Set the background color
        );
      },
    ).then((_) {
      // After the countdown, navigate to the gamePage with selected difficulty and length
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GamePage(
            selectedDifficulty: selectedDifficulty,
            selectedLength: selectedLength,
            selectedLocation: selectedLocation,
          ),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    _getList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('', style: TextStyle(color: Color(0xFF40531B))),
        backgroundColor: const Color(0xFF7AA095),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
            mainAxisAlignment: MainAxisAlignment.start, // Center content vertically
            children: [
              const Text(
                'Single Player Mode',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF40531B)),
              ),
              const SizedBox(height: 20.0),
              const Text('Location', style: TextStyle(color: Color(0xFF40531B))),
              DropdownButton<String>(
                value: selectedLocation,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLocation = newValue!;
                  });
                },
                items: _locations //TODO add option for local files: done
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Length', style: TextStyle(color: Color(0xFF40531B))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the Row horizontally
                children: [
                  SinglePlayerButton(
                    text: 'Short',
                    selected: selectedLength == 'Short',
                    onPressed: () {
                      setState(() {
                        selectedLength = 'Short';
                      });
                    },
                  ),
                  SinglePlayerButton(
                    text: 'Medium',
                    selected: selectedLength == 'Medium',
                    onPressed: () {
                      setState(() {
                        selectedLength = 'Medium';
                      });
                    },
                  ),
                  SinglePlayerButton(
                    text: 'Long',
                    selected: selectedLength == 'Long',
                    onPressed: () {
                      setState(() {
                        selectedLength = 'Long';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text('Difficulty', style: TextStyle(color: Color(0xFF40531B))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the Row horizontally
                children: [
                  SinglePlayerButton(
                    text: 'Easy',
                    selected: selectedDifficulty == 'Easy',
                    onPressed: () {
                      setState(() {
                        selectedDifficulty = 'Easy';
                      });
                    },
                  ),
                  SinglePlayerButton(
                    text: 'Medium',
                    selected: selectedDifficulty == 'Medium',
                    onPressed: () {
                      setState(() {
                        selectedDifficulty = 'Medium';
                      });
                    },
                  ),
                  SinglePlayerButton(
                    text: 'Hard',
                    selected: selectedDifficulty == 'Hard',
                    onPressed: () {
                      setState(() {
                        selectedDifficulty = 'Hard';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 46.0),
              ElevatedButton(
                onPressed: () {
                  showCountdownPopup();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAFBC88),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text(
                  'Ready',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({super.key});

  @override
  CountdownWidgetState createState() => CountdownWidgetState();
}

class CountdownWidgetState extends State<CountdownWidget> {
  int countdown = 3;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (countdown > 1) {
        setState(() {
          countdown--;
        });
        startCountdown();
      } else {
        Navigator.of(context).pop(); // Close the popup after countdown
      }
    });
  }

  @override
    Widget build(BuildContext context) {
      return Text(
        '$countdown',
        style: const TextStyle(fontSize: 24, color: Colors.white),
      );
    }
}


