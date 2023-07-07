import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDatabase {
  Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  _initDatabase() async {
    String getPath = await getDatabasesPath();
    String path = join(getPath, 'what_todo.db');

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return db;
  }

  // on create database
  _onCreate(Database db, int version) async {
    await db.execute('''
     CREATE TABLE "todos" (
      "id"     INTEGER  NOT NULL  PRIMARY KEY  AUTOINCREMENT,
      "title"  TEXT     NOT NULL ,
      "status" TEXT     NOT NULL
     )

    ''');

    print("================= database created ==================");
  }

  // on upgrading database
  _onUpgrade(Database db, int oldVersion, int newVersion) {}

  // get data from database
  Future<List<Map>> getData() async {
    Database? db = await database;

    List<Map> response = await db!.rawQuery('SELECT * FROM todos');

    return response;
  }

  // insert data
  Future<int> insertData({required String taskTitle}) async {
    Database? db = await database;

    int response = await db!.rawInsert('''
       INSERT INTO "todos" (title, status) VALUES ("$taskTitle", "new")
    ''');

    return response;
  }

  // delete data
  Future<int> deleteData({required int id}) async {
    Database? db = await database;

    int response = await db!.rawDelete('''
       DELETE FROM "todos" WHERE "id" = $id
    ''');

    return response;
  }

  // update data
  Future<int> updateData({required String newTitle, required int id}) async {
    Database? db = await database;

    int response = await db!.rawDelete('''
       UPDATE "todos" 
       SET "title" = "$newTitle"
       WHERE "id" = $id
    ''');

    return response;
  }

  Future<int> updateTaskStatus(
      {required String newStatus, required int id}) async {
    Database? db = await database;

    int response = await db!.rawDelete('''
       UPDATE "todos" 
       SET "status" = "$newStatus"
       WHERE "id" = $id
    ''');

    return response;
  }
}
