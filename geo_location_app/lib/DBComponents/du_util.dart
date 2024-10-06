import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

// IDK how local storage will work when shared on github
// this does nothing for now, just waiting to be used


class DBUtil{
  static Future init() async{
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'location_manager.db'),
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE locations(id INTEGER PRIMARY KEY, lat DOUBLE, long DOUBLE, imgLink STRING)");
      },
      version: 1,
    );
    print("Created database $database");
    return database;
  }
}