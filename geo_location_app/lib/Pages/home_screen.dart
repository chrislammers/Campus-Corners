// Importing necessary packages and custom screens
import 'dart:math';
import 'package:flutter/material.dart';
import 'choose_location.dart';
import 'how_to_play.dart';
import 'single_player_page.dart';
import 'settings_page.dart';

// HomeScreen widget for the main UI of the application
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieving screen dimensions for responsive design
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Building the main scaffold of the home screen
    return Scaffold(
      body: Center(
        child: Container(
          // Styling the container with a gradient background and border radius
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF06386f), Color(0xFF0b7952)],
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          // Adding padding and a stack for layout structure
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Stack(
            children: [
              // CustomPaint widget to draw circles on the background
              CustomPaint(
                painter: CirclePainter(MediaQuery.of(context).size),
                size: Size(screenWidth, screenHeight),
              ),
              // Column for arranging various UI elements
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Row with buttons for navigating to different screens
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HomeButton('Locations', Icons.location_on, navigateToChooseLocation),
                        HomeButton('How to Play', Icons.help, navigateToHowToPlay),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Title and Play button section
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.02),
                        child: Text(
                          'Campus Corners',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: screenHeight * 0.09, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                  // Play button with icon and label
                  ElevatedButton.icon(
                    onPressed: () {
                      navigateSinglePlayer(context);
                    },
                    icon: Icon(Icons.play_arrow, size: screenWidth * 0.06, color: Colors.white),
                    label: const Text(
                      'Play',
                      style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Settings button at the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the icons horizontally
                    children: [
                      HomeButton('', Icons.settings, navigateSettingsPage),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation methods for different screens
  void navigateToChooseLocation(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChooseLocationScreen()));
  }

  void navigateToHowToPlay(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HowToPlayScreen()));
  }

  void navigateSinglePlayer(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SinglePlayerPage()));
  }

  void navigateSettingsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
  }
}

// HomeButton widget for custom-styled buttons on the home screen
class HomeButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Function(BuildContext) onPressed;

  const HomeButton(this.text, this.iconData, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    // GestureDetector for handling button taps
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed(context);
        }
      },
      // Container for button styling
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.transparent,
        ),
        // Row with icon and text for button content
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 24, color: Colors.white),
            const SizedBox(width: 8.0),
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomPainter for drawing circles on the background
class CirclePainter extends CustomPainter {
  List<Offset> circles = [];

  // Constructor to generate random circles based on screen size
  CirclePainter(Size size) {
    generateCircles(size);
  }

  // Method to generate non-overlapping circles with a minimum distance
  void generateCircles(Size size) {
    final random = Random();
    const minDistance = 100.0;

    for (int i = 0; i < 12; i++) {
      Offset offset;
      do {
        offset = Offset(random.nextDouble() * size.width, random.nextDouble() * size.height);
      } while (circles.any((circle) => _calculateDistance(circle, offset) < minDistance));

      circles.add(offset);
    }
  }

  // Method to paint circles with a gradient shader
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0b7952), Color(0xFF06386f)],
      ).createShader(Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)));

    for (int i = 0; i < circles.length; i++) {
      const radius = 50.0;
      canvas.drawCircle(circles[i], radius, paint);
    }
  }

  // Helper method to calculate distance between two points
  double _calculateDistance(Offset p1, Offset p2) {
    return sqrt(pow(p1.dx - p2.dx, 2) + pow(p1.dy - p2.dy, 2));
  }

  // Indicator to repaint when needed
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
