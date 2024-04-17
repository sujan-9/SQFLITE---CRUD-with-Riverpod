import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:sqfliteflutter/model/todo_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  static const dbName = 'todo.db';
  static const dbVersion = 1;
  static const dbTablename = 'Todo';
  static const createSql =
      'CREATE TABLE $dbTablename ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT, $columnBody TEXT)';

  // static const createSql =
  //     'CREATE TABLE $dbTablename ($columnId INTEGER PRIMARY KEY , $columnTitle TEXT, $columnBody TEXT)';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnBody = 'body';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(createSql);
  }

  // Create operation
  Future<int> insertTodo(Todo todo) async {
    final dbClient = await db;
    return await dbClient.insert(dbTablename, todo.toMap());
  }

  // Read operation: Get all todos
  Future<List<Todo>> getAllTodos() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(dbTablename);
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
      );
    });
  }

  // Update operation
  Future<int> updateTodo(Todo todo) async {
    final dbClient = await db;
    return await dbClient.update(
      dbTablename,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // Delete operation
  Future<int> deleteTodo(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      dbTablename,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//delete whole data
  Future<int> clearTableData() async {
    final dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM $dbTablename');
  }
}
