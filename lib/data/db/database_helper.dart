import 'package:path/path.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database _database;
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();
  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableResto = 'restaurant';
  static const String _tableCategory = 'restaurant_detail';
  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'note_db.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''DROP TABLE IF EXISTS $_tableResto''',
        );
        await db.execute(
          '''CREATE TABLE $_tableResto (
              id VARCHAR(45) NOT NULL  ,
              name VARCHAR(45) NULL,
              description VARCHAR(45) NULL,
              pictureId VARCHAR(200) NULL,
              city VARCHAR(45) NULL,
              rating DOUBLE NULL,
              PRIMARY KEY (id)
              )''',
        );
        await db.execute(
          '''DROP TABLE IF EXISTS $_tableCategory''',
        );
        await db.execute('''
          CREATE TABLE $_tableCategory (
              error TEXT,
              message TEXT,
              id TEXT,
              name TEXT,
              description TEXT,
              city TEXT,
              address TEXT,
              pictureId INTEGER,
              categories_name TEXT,
              menus_foods_name TEXT,
              menus_drinks_name TEXT,
              rating NUMERIC,
              customerReviews_name TEXT,
              customerReviews_review TEXT,
              customerReviews_date TEXT,
              resto_id VARCHAR(45) NOT NULL,
              PRIMARY KEY (id),  
              FOREIGN KEY (resto_id) REFERENCES $_tableResto (id) ON DELETE NO ACTION ON UPDATE NO ACTION
          )
          ''');
      },
      version: 1,
    );

    return db;
  }

  Future<void> insertResto(Restaurant resto) async {
    final Database db = await database;
    await db.insert(_tableResto, resto.toMap());
  }

  Future<List<Restaurant>> getRestos() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableResto);
    return results.map((res) => Restaurant.fromMap(res)).toList();
  }

  Future<Restaurant> getRestoById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableResto,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.map((res) => Restaurant.fromMap(res)).first;
  }

  Future<void> updateNote(Restaurant note) async {
    final db = await database;

    await db.update(
      _tableCategory,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteResto(id) async {
    final db = await database;

    await db.delete(
      _tableResto,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
