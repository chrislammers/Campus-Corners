// Importing Flutter Material package
import 'package:flutter/material.dart';

// ThemeProvider class extending ChangeNotifier for theme management
class ThemeProvider extends ChangeNotifier {
  // Default theme is light
  ThemeData _currentTheme = ThemeData.light();

  // Getter for the current theme
  ThemeData get currentTheme => _currentTheme;

  // Method to toggle between light and dark themes
  void toggleTheme() {
    _currentTheme = _currentTheme == ThemeData.light()
        ? ThemeData.dark()
        : ThemeData.light();

    // Notifying listeners to update UI with the new theme
    notifyListeners();
  }
}
