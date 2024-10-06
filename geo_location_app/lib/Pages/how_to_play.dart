import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' ', style: TextStyle(color: Color(0xFF40531B))),
        backgroundColor: const Color(0xFF7AA095),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF7AA095),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(16),
                child: const Icon(
                  Icons.info,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'How to Play',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF40531B)),
              ),
              const SizedBox(height: 20),
              _buildHeader('Gameplay'),
              _buildParagraph(
                'This app is a scavenger hunt location finding game.'
                'To play the game you must choose from the location sets available, or add you own from the locations screen'
                '\n\nThe goal of the game:\n'
                'The objective of the game is to find the location each image you are shown was taken from. '
                'When you think you are in the right spot, click the \'Submit\' button to submit your guess and move on to the next image. '
                'Repeat this till the end and you will get a score with how well you did! '
                'Notifications will be sent to you when there is a minute left on the timer to remind you that time is running out.'
                '\n\n Game Options:\n '
                'Difficulty - amount of time you have to find each image and number of hints you get\n'
                'Length - the number of images you will be shown\n'
                '\nWhen you are ready, click the Ready button and have fun! '
                '\nThe map icon in the top right will open up a map'
                '\nThe light bulb is a hint button, when clicked it will show you how far you are away from the pictures taken location. The number of hints you get is dependent on the difficulty. ',

              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back to the previous screen (HomeScreen.dart)
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF7AA095),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Start Playing',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF40531B)),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
    );
  }
}
