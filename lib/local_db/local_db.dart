import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSql {
  static final table = 'flutter_calendar_events';
  static final dbName = 'flutter_calendar_database.db';

  static final columnId = '_id';
  static final columnDescription = 'description';
  static final columnWhenCreate = 'time';
  static final columnWhenMustComplete = 'whenMustComplete';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table ( $columnId INTEGER PRIMARY KEY, $columnDescription TEXT NOT NULL, $columnWhenCreate TEXT NOT NULL, $columnWhenMustComplete TEXT NOT NULL )');
  }

  Future<int> insert(Map<String, dynamic> task) async {
    Database db = await database;
    return await db.insert(table, task);
  }

  Future<List<Map<String, dynamic>>?> getTasks(String time) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(table,
        columns: [
          columnId,
          columnDescription,
          columnWhenCreate,
          columnWhenMustComplete
        ],
        where: '$columnWhenCreate = ?',
        whereArgs: [time]);
    if (maps.length > 0) {
      return maps;
    }
    return null;
  }

  Future<int?> countOfRows(String time) async {
    Database db = await database;
    List<Map> maps = await db.query(table,
        columns: [
          columnId,
          columnDescription,
          columnWhenCreate,
          columnWhenMustComplete
        ],
        where: '$columnWhenCreate = ?',
        whereArgs: [time]);
    if (maps.length > 0) {
      return maps.length;
    }
    return null;
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
