# flutter_not_sepeti

A notepad application made with Android Studio and Flutter. This application uses sqlite for data storing.

## path provider

path_provider is a Flutter plugin for finding commonly used locations on the filesystem. Supports Android, iOS, Linux, macOS and Windows. Not all methods are supported on all platforms.

pubspec.yaml

    path_provider: ^2.0.0

## sqlite

sqlite is SQLite plugin for Flutter. Supports iOS, Android and MacOS.

pubspec.yaml

    sqflite: any

    assets:
    - assets/notlar.db

We first need a db file "notlar.db" made in DB browser and placed in assets folder for this project

database_helper.dart

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

    Future<List<Map<String, dynamic>>> notlariGetir() async {
      var db = await _getDatabase();
      var sonuc = await db.rawQuery('SELECT * FROM "not" INNER JOIN Kategori on "not".kategoriID = Kategori.kategoriID');
      return sonuc;
    }

## synchronized

Basic lock mechanism to prevent concurrent access to asynchronous code.

The name is biased as we are single threaded in Dart. However since we write asychronous code (await) like we would write synchronous code, it makes the overall API feel the same.

The goal is to ensure for a single process (single isolate) that some asynchronous operations can run without conflict. It won't solve cross-process (or cross-isolate) synchronization.

pubspec.yaml

    synchronized: ^3.4.0

database_helper.dart

    var lock = Lock();
    Database? db;

    await lock.synchronized(() async {
      if (db == null) {
        // Lines of code
        db = await openDatabase(path);
      }
    });
    return db!;

## path

A comprehensive, cross-platform path manipulation library for Dart.

The path package provides common operations for manipulating paths: joining, splitting, normalizing, etc.

pubspec.yaml

    path: ^1.9.1

database_helper.dart

    var path = join(databasesPath, "appDB.db");
    var file = File(path);
  
    if (!await file.exists()) {
      // Code lines

