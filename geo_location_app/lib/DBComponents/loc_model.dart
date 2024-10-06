import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo_location_app/DBComponents/geo_location.dart';
import 'package:geo_location_app/DBComponents/du_util.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class LocModel {
  Future<int> insertLoc(GeoLocation loc) async {
    final db = await DBUtil.init();
    return db.insert(
      'locations',
      loc.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<GeoLocation>> getAllLocs() async{
    final db = await DBUtil.init();
    final List maps = await db.query('locations');
    List<GeoLocation> result = [];
    // print('${maps[0]}');
    // print(maps.length);

    for (int i = 0; i < maps.length; i++){
      result.add(
          GeoLocation.fromMap(maps[i])
      );
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllLocsAsMap() async {
    final db = await DBUtil.init();
    final List maps = await db.query('locations');
    List<Map<String, dynamic>> result = [];

    late GeoLocation current;
    for (int ii=0; ii<maps.length; ii++) {
      current = GeoLocation.fromMap(maps[ii]);
      result.add(
        {
          'coordinates': GeoPoint(current.lat!, current.long!),
          'image': current.imgLink
        }
      );
    }
    return result;
  }

  Future<int> deleteLocWithId(int id) async{
    final db = await DBUtil.init();
    return db.delete(
      'locations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
