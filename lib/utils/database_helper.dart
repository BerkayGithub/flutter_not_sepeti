import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' hide ByteData;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future<Database> _initializeDatabase() async {
    var lock = Lock();
    Database? db;

    await lock.synchronized(() async {
      if (db == null) {
        var databasesPath = await getDatabasesPath();
        var path = join(databasesPath, "appDB.db");
        var file = File(path);

        if (!await file.exists()) {
          ByteData data = (await rootBundle.load(
            join("assets", "notlar.db"),
          ));
          List<int> bytes = data.buffer.asUint8List(
            data.offsetInBytes,
            data.lengthInBytes,
          );
          await File(path).writeAsBytes(bytes);
        }
        db = await openDatabase(path);
      }
    });
    return db!;
    }

    kategorileriGetir() async{
    var db = await _getDatabase();
    var sonuc = await db.query("kategori");
    print(sonuc);

    await db.insert("kategori", {'kategoriBaslik': "Test kategorisi 3"});
    var sonu2 = await db.query("kategori");
    print(sonu2);
    }
}
