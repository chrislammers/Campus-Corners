import 'package:flutter/material.dart';
import '../utils.dart';

// GameSummary widget displays a summary of the game, including location details and an overall result.
class GameSummary extends StatelessWidget {
  // List of saved locations and selected locations for the game.
  final List<Map<String, dynamic>> savedLocations;
  final List<Map<String, dynamic>> selectedLocations;

  // Constructor for GameSummary widget.
  const GameSummary({super.key, required this.savedLocations, required this.selectedLocations});

  // Build method for creating the UI of the GameSummary widget.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable the back button
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Game Summary', style: TextStyle(color: Color(0xFF40531B))),
          backgroundColor: const Color(0xFF7AA095),
          automaticallyImplyLeading: false, // Disable the back button
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF40531B)),
              ),
              const SizedBox(height: 20),
              buildSummaryTable(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the home screen
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7AA095),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Finish', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the summary table using FutureBuilder to handle asynchronous data fetching.
  Widget buildSummaryTable() {
    return FutureBuilder(
      future: fetchData(), // Replace with your asynchronous operation to fetch data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading screen while waiting for data
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Show an error message if an error occurs
          return Text('Error: ${snapshot.error}');
        } else {
          // Display the summary table once data is available
          return Column(
            children: [
              SizedBox(
                height: 300, // Set a fixed height for the table
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Location',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Distance (meters)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Result',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      savedLocations.length,
                          (index) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Location ${index + 1}')),
                          DataCell(
                            Text(
                              Utils.calculateDistance(
                                savedLocations[index]['guessed_coordinates'],
                                selectedLocations[index]['coordinates'],
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              calculateResult(
                                savedLocations[index]['guessed_coordinates'],
                                selectedLocations[index]['coordinates'],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Display the overall result using FutureBuilder
              FutureBuilder(
                future: calculateOverallResult(), // Replace with your asynchronous operation to calculate the overall result
                builder: (context, overallResultSnapshot) {
                  if (overallResultSnapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading screen while waiting for data
                    return const CircularProgressIndicator();
                  } else if (overallResultSnapshot.hasError) {
                    // Show an error message if an error occurs
                    return Text('Error: ${overallResultSnapshot.error}');
                  } else {
                    // Display the overall result
                    return Text(
                      'Overall Result: ${overallResultSnapshot.data}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF40531B)),
                    );
                  }
                },
              ),
            ],
          );
        }
      },
    );
  }

  // Asynchronous method to calculate the overall result based on the average of letter grades.
  Future<String> calculateOverallResult() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating a delay for demonstration

    // List to store individual letter grades
    List<String> letterGrades = [];

    // Calculate letter grade for each location and store in the list
    for (int i = 0; i < savedLocations.length; i++) {
      String letterGrade = calculateResult(
        savedLocations[i]['guessed_coordinates'],
        selectedLocations[i]['coordinates'],
      );
      letterGrades.add(letterGrade);
    }

    // Calculate the average letter grade
    double totalGradePoints = 0.0;

    for (String letterGrade in letterGrades) {
      // Map letter grades to numeric values for averaging
      switch (letterGrade) {
        case 'S':
          totalGradePoints += 5.0;
          break;
        case 'A':
          totalGradePoints += 4.0;
          break;
        case 'B':
          totalGradePoints += 3.0;
          break;
        case 'C':
          totalGradePoints += 2.0;
          break;
        case 'D':
          totalGradePoints += 1.0;
          break;
        case 'F':
          totalGradePoints += 0.0;
          break;
      }
    }

    double averageGrade = totalGradePoints / letterGrades.length;

    // Map the average numeric grade back to the letter grade
    if (averageGrade >= 4.5) {
      return 'S';
    } else if (averageGrade >= 3.5) {
      return 'A';
    } else if (averageGrade >= 2.5) {
      return 'B';
    } else if (averageGrade >= 1.5) {
      return 'C';
    } else if (averageGrade >= 0.5) {
      return 'D';
    } else {
      return 'F';
    }
  }

  // Asynchronous method to fetch data, waiting until savedLocations and selectedLocations have the same size.
  Future<void> fetchData() async {
    while (savedLocations.length != selectedLocations.length) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  // Method to calculate the result based on the distance.
  String calculateResult(List<dynamic> guessedCoordinates, dynamic actualCoordinates) {
    double distance = double.parse(Utils.calculateDistance(guessedCoordinates, actualCoordinates));

    if (distance < 1) {
      return 'S';
    } else if (distance >= 1 && distance <= 5) {
      return 'A';
    } else if (distance > 5 && distance <= 8) {
      return 'B';
    } else if (distance > 8 && distance <= 12) {
      return 'C';
    } else if (distance > 12 && distance <= 16) {
      return 'D';
    } else {
      return 'F';
    }
  }
}
