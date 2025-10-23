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
    var sonuc = await db.update('kategori', kategori.toMap(), where: "kategoriID = ?", whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  Future<int> kategoriSil(Kategori kategori) async{
    var db = await _getDatabase();
    var sonuc = await db.delete('kategori', where: "kategoriID = ?", whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery('SELECT * FROM "not" INNER JOIN Kategori on "not".kategoriID = Kategori.kategoriID');
    return sonuc;
  }

  Future<List<Not>> notListesiniGetir() async {
    var tumNotlar = List<Not>.empty(growable: true);
    await notlariGetir().then((notListesi) {
      for (Map<String, dynamic> not in notListesi) {
        tumNotlar.add(Not.fromMap(not));
      }
    });
    return tumNotlar;
  }

  Future<int> notEkle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db.insert('not', not.toMap());
    return sonuc;
  }

  Future<int> notGuncelle(Not not) async{
    var db = await _getDatabase();
    var sonuc = await db.update('not', not.toMap(), where: "notID = ?", whereArgs: [not.notID]);
    return sonuc;
  }

  Future<int> notSil(int notID) async{
    var db = await _getDatabase();
    var sonuc = await db.delete('not', where: "notID = ?", whereArgs: [notID]);
    return sonuc;
  }

  String dateFormat(DateTime tm){

    DateTime today = DateTime.now();
    Duration oneDay = Duration(days: 1);
    Duration twoDay = Duration(days: 2);
    Duration oneWeek = Duration(days: 7);
    String month = '';
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylük";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";


  }
}
