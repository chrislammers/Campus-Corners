// Importing necessary packages and files
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/home_screen.dart';
import 'DBComponents/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'theme_provider.dart';

// Creating a global instance of FlutterLocalNotificationsPlugin
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Main function to initialize the app
void main() async {
  // Ensuring Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing local notifications
  await initNotifications();

  // Initializing Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Running the app with a theme provider
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

// Function to initialize local notifications
Future<void> initNotifications() async {
  // Defining Android initialization settings for notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher'); //TODO replace icon

  // Combining initialization settings
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  // Initializing FlutterLocalNotificationsPlugin
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

// MyApp widget for the main MaterialApp
class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    // Accessing the theme provider
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Building the MaterialApp with the dynamic theme
    return MaterialApp(
      theme: themeProvider.currentTheme, // Set the theme dynamically
      home: const HomeScreen(),
    );
  }
}
