import 'dart:io';
import 'package:password_manager/database/db_model.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:synchronized/synchronized.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static DBHelper _dbHelper;
  static Database _database;

  factory DBHelper() {
    if (_dbHelper == null) {
      return DBHelper._internal();
    } else
      return _dbHelper;
  }

  DBHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await initializeDB();
      return _database;
    } else
      return _database;
  }

  initializeDB() async {
    var lock = Lock();
    Database _db;

    if (_db == null) {
      await lock.synchronized(() async {
        if (_db == null) {
          var databasesPath = await getDatabasesPath();
          var path = join(databasesPath, "passMan");
          var file = new File(path);

          // check if file exists
          if (!await file.exists()) {
            // Copy from asset
            ByteData data = await rootBundle.load(join("assets", "passMan"));
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await new File(path).writeAsBytes(bytes);
          }
          // open the database
          _db = await openDatabase(path);
        }
      });
    }
    return _db;
  }

  Future<List<Map<String, dynamic>>> listPass() async {
    var _db = await _getDatabase();
    var resp = await _db.query("passwords");
    return resp;
  }

  Future<int> addPass(DBModel dbModel) async {
    var _db = await _getDatabase();
    var resp = await _db.insert("passwords", dbModel.toMap());
    return resp;
  }

  Future<int> updatePass(DBModel dbModel) async {
    var _db = await _getDatabase();
    var resp = await _db.update("passwords", dbModel.toMap(),
        where: 'id =?', whereArgs: [dbModel.id]);
    return resp;
  }

  Future<int> deletePass(int id) async {
    var _db = await _getDatabase();
    var resp = await _db.delete("passwords", where: "id =?", whereArgs: [id]);
    return resp;
  }
}
