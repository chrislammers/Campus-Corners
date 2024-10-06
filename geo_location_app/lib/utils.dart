// utils.dart
import 'dart:math' show pow, sqrt, sin, cos, atan2, pi;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';

//class to store static functions that are universally useful
class Utils {

  // This constructor ensures that the class cannot be instantiated.
  Utils._();

  //Method to display notifications given a title and body
  static void showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'main_channel_id', 'main_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    //const String imagePath = 'Assets/image.jpg';

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  //Method to calculate distance based on geo coordinates and return distance in meters
  static String calculateDistance(List<dynamic> guessedCoordinates, dynamic actualCoordinates) {
    // Handle the GeoPoint type
    double guessedLatitude = guessedCoordinates[0];
    double guessedLongitude = guessedCoordinates[1];
    double actualLatitude = actualCoordinates.latitude;
    double actualLongitude = actualCoordinates.longitude;

    // Calculate distance using the Haversine formula
    double distance = calculateHaversineDistance(
      guessedLatitude,
      guessedLongitude,
      actualLatitude,
      actualLongitude,
    );

    // Convert distance to meters
    double distanceInMeters = distance * 1000;

    return distanceInMeters.toStringAsFixed(2);
  }

  //Method for applying the haversine distance formula
  static double calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0; // Earth radius in kilometers

    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(lon2 - lon1);

    double a = pow(sin(dLat / 2), 2) +
        cos(toRadians(lat1)) * cos(toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  //method to convert from degrees to radians
  static double toRadians(double degree) {
    return degree * (pi / 180);
  }

  // Format time in seconds to a readable format
  static String formatTime(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

}

