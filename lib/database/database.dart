import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Db {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'notes_blueprint.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE notes(randomId TEXT PRIMARY KEY, title TEXT, content TEXT)',
        );
        await db.execute(
          'CREATE TABLE color(key INTEGER PRIMARY KEY, primarySwatch INTEGER, backgroundColor INTEGER, cardColor INTEGER, canvasColor INTEGER, textTheme INTEGER, iconTheme)',
        );
        await db.execute(
          'CREATE TABLE picture(belongsTo TEXT PRIMARY KEY, picturePath TEXT)',
        );
      },
      version: 1,
    );
  }

  // Future<Database> initializeDB() async {
  //   String path = await getDatabasesPath();
  //   return openDatabase(
  //     join(path, 'notes_blueprint.db'),
  //     onCreate: (db, version) async {
  //       await db.execute(
  //         'CREATE TABLE notes(randomId TEXT PRIMARY KEY, title TEXT, content TEXT)',
  //       );
  //       await db.execute(
  //         'CREATE TABLE color(key INTEGER PRIMARY KEY, primarySwatch INTEGER, backgroundColor INTEGER, cardColor INTEGER, canvasColor INTEGER, textTheme INTEGER, iconTheme)',
  //       );
  //     },
  //     version: 1,
  //   );
  // }
}
