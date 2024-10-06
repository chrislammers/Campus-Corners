// Importing necessary packages and classes
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geo_location_app/theme_provider.dart';

// Creating a settings page widget
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

// State class for the SettingsPage widget
class _SettingsPageState extends State<SettingsPage> {
  // Boolean flags to manage the expansion state of various settings sections
  bool notificationFrequencyExpanded = false;
  bool legalInfoExpanded = false;
  bool privacyPolicyExpanded = false;
  bool patchNotesExpanded = false;
  bool creditsExpanded = false;

  // Variable to store the selected language
  String selectedLanguage = 'English';

  // Function to show a language picker dialog
  void _showPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Building an alert dialog with a list of language options
        return AlertDialog(
          title: const Text("Select an option"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildLanguageItem("English"),
                _buildLanguageItem("English(UK)"),
                _buildLanguageItem("English(US)"),
                // Add more languages as needed
              ],
            ),
          ),
          actions: [
            // Adding a cancel button to close the dialog
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Building a language selection item for the language picker dialog
  Widget _buildLanguageItem(String language) {
    return ListTile(
      title: Text(language),
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
        Navigator.of(context).pop();
      },
    );
  }

  // Building an expansion tile for different settings sections
  Widget _buildExpansionTile(
      String title,
      bool isExpanded,
      Function(bool) onExpansionChanged,
      String bodyText,
      ) {
    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: isExpanded,
      onExpansionChanged: onExpansionChanged,
      children: [
        ListTile(
          title: Text(bodyText),
        ),
      ],
    );
  }

  // Building the overall UI of the settings page
  @override
  Widget build(BuildContext context) {
    // Accessing the theme provider using a provider to manage app theme
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Building the scaffold with an app bar and settings content
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          // Adding a button to toggle between dark and light mode
          IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // General Settings Section
              const Text(
                'General Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dark Mode'),
                  // Switch to toggle dark mode
                  Switch(
                    value: themeProvider.currentTheme == ThemeData.dark(),
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  ),
                ],
              ),
              const Divider(),

              // Language Settings Section
              const Text(
                'Language Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Text('App Language'),
              // Button to open language picker dialog
              ElevatedButton(
                onPressed: _showPickerDialog,
                child: Text(selectedLanguage),
              ),
              const Divider(),
              const SizedBox(height: 16.0),

              // Legal Information Expansion Tile
              _buildExpansionTile(
                'Legal Information',
                legalInfoExpanded,
                    (isExpanded) {
                  setState(() {
                    legalInfoExpanded = isExpanded;
                  });
                },
                'This app has no legal protection in any way and we have no way of stopping you from copying or reproducing any part of our application',
              ),
              const SizedBox(height: 16.0),

              // Privacy Policy Expansion Tile
              _buildExpansionTile(
                'Privacy Policy',
                privacyPolicyExpanded,
                    (isExpanded) {
                  setState(() {
                    privacyPolicyExpanded = isExpanded;
                  });
                },
                'We do not store any data you do not enter into the system through creating a local Location set. We do not use this information for anything other than the functionality of the game',
              ),
              const SizedBox(height: 16.0),

              // Patch Notes Expansion Tile
              _buildExpansionTile(
                'Patch Notes',
                patchNotesExpanded,
                    (isExpanded) {
                  setState(() {
                    patchNotesExpanded = isExpanded;
                  });
                },
                'Current Version: Beta 0.0.1',
              ),
              const SizedBox(height: 16.0),

              // Credits Expansion Tile
              _buildExpansionTile(
                'Credits',
                creditsExpanded,
                    (isExpanded) {
                  setState(() {
                    creditsExpanded = isExpanded;
                  });
                },
                'App Developers: Alexie Linardatos, Giancarlo Giannetti, Chris Lammers',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Main function to run the app and initialize the settings page
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MaterialApp(
        home: SettingsPage(),
      ),
    ),
  );
}
