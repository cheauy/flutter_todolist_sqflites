import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todolists/databaseService/todomodel.dart';

class DatabaseService {
  Future<Database> initData() async {
    var databasepath = await getDatabasesPath();
    String path = join(databasepath, 'demo.db');
    return openDatabase(path, version: 1, onCreate: oncreate);
  }

  Future<void> oncreate(Database database, int version) async {
    await database.execute(
        "CREATE TABLE IF NOT EXISTS list(id INTEGER PRIMARY KEY autoincrement, title TEXT Not null , categories TEXT)");
  }

  Future<void> createlist(TodoListmodel todoListmodel) async {
    var db = await initData();
    int result = await db.insert(
      "list",
      todoListmodel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(result);
  }

  Future<List<TodoListmodel>> readlist() async {
    var db = await initData();
    var data = await db.query('list');
    return titlefromMap(data);
  }

  Future<void> deletelist(int id) async {
    var db = await initData();
    var data = await db.delete('list', where: 'id=$id');
    print(data);
  }

  Future<void> updatelist(TodoListmodel todoListmodel, int id) async {
    var db = await initData();
    int result =
        await db.update('list', todoListmodel.toMap(), where: "id=$id");
    print(result);
  }

  Future<List<TodoListmodel>> isTitleExist(String title) async {
    var db = await initData();

    var data = await db.rawQuery(
      'SeLECT * FROM list WHERE title="?";',
    );
    return titlefromMap(data);
  }
}
