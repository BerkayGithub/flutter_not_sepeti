import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' hide ByteData;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import '../models/Kategori.dart';
import '../models/not.dart';

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
          ByteData data = (await rootBundle.load(join("assets", "notlar.db")));
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

  Future<List<Map<String, dynamic>>> kategorileriGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query("kategori");
    return sonuc;
  }

  Future<int> kategoriEkle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.insert('kategori', kategori.toMap());
    return sonuc;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async{
    var db = await _getDatabase();
    var sonuc = await db.update('kategori', kategori.toMap(), where: "kategoriID", whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  Future<int> kategoriSil(Kategori kategori) async{
    var db = await _getDatabase();
    var sonuc = await db.delete('kategori', where: "kategoriID", whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query("not", orderBy: "notID DESC");
    return sonuc;
  }

  Future<int> notEkle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db.insert('not', not.toMap());
    return sonuc;
  }

  Future<int> notGuncelle(Not not) async{
    var db = await _getDatabase();
    var sonuc = await db.update('not', not.toMap(), where: "notID", whereArgs: [not.notID]);
    return sonuc;
  }

  Future<int> notSil(Not not) async{
    var db = await _getDatabase();
    var sonuc = await db.delete('not', where: "notID", whereArgs: [not.notID]);
    return sonuc;
  }
}
