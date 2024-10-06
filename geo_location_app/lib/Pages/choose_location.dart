import 'package:flutter/material.dart';
import 'package:geo_location_app/Pages/home_screen.dart';
import 'package:geo_location_app/Pages/add_location.dart';
import '../DBComponents/db_manager_page.dart';

class ChooseLocationScreen extends StatelessWidget {
  const ChooseLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('', style: TextStyle(fontFamily: 'BlockyFont', color: Color(0xFF40531B))),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DBManager()));
            },
            icon: const Icon(Icons.menu_open),
          ),
        ],
        backgroundColor: const Color(0xFF7AA095),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToTakingPhotoPage(context);
        },
        backgroundColor: const Color(0xFF618B4A),
        child: const Icon(Icons.add),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Location Sets Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'BlockyFont', color: Color(0xFF40531B)),
              ),
            ),
            SizedBox(height: 26.0),
            LocationLabel(
              'Ontario Tech',
              description: 'Explore locations around Ontario Tech campus.',
            ),
            SizedBox(height: 16.0),
            LocationLabel(
              'Durham College',
              description: 'Discover interesting places within Durham College campus.',
            ),
            SizedBox(height: 16.0),
            LocationLabel(
              'Local Storage',
              description: 'If you add at least 15 local locations you can choose to use your own location set. Click the + button to add a new location.',
            ),
            SizedBox(height: 16.0),
            LocationButtonLocked(
              description: 'More locations to be added soon.',
            ),
          ],
        ),
      ),
    );
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  void navigateToTakingPhotoPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateLocation()));
  }
}

class LocationLabel extends StatelessWidget {
  final String text;
  final String description;

  const LocationLabel(this.text, {super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'BlockyFont', color: Colors.black),
        ),
        const SizedBox(height: 8.0),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}

class LocationButtonLocked extends StatelessWidget {
  final String description;

  const LocationButtonLocked({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock),
            SizedBox(width: 8.0),
            Text('Locked', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'BlockyFont')),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}
