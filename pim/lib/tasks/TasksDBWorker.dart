import 'package:pim/tasks/TasksModel.dart';
import 'package:pim/utils.dart' as utils;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TasksDBWorker {
  TasksDBWorker._();
  static final TasksDBWorker db = TasksDBWorker._();

  Database _db;

  Future<Database> get database async {
    if (_db == null) {
      _db = await init();
    }

    return _db;
  }

  Future<Database> init() async {
    String path = join(utils.docsDir.path, "tasks.db");

    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (newDb, vers) async {
      await newDb.execute("CREATE TABLE IF NOT EXISTS tasks ("
          "id INTEGER PRIMARY KEY,"
          "description TEXT,"
          "due TEXT,"
          "completed TEXT"
          ")");
    });

    return db;
  }

  Task mapToTask(Map m) {
    Task t = Task();
    t.id = m["id"];
    t.description = m["description"];
    t.due = m["due"];
    t.completed = m["completed"];

    return t;
  }

  Map<String, dynamic> taskToMap(Task t) {
    Map<String, dynamic> m = Map<String, dynamic>();
    m["id"] = t.id;
    m["description"] = t.description;
    m["due"] = t.due;
    m["completed"] = t.completed;

    return m;
  }

  Future<void> create(Task t) async {
    Database db = await database;

    var res = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM tasks");

    int id = res.first["id"];

    if (id == null) {
      id = 1;
    }

    return await db
        .rawInsert("INSERT INTO tasks (id, description, due, completed) "
            "VALUES (?, ?, ?, ?)",
            [id, t.description, t.due, t.completed],
        );
  }

  Future<Task> get(int taskId) async {
    Database db = await database;

    var res = await db.query(
      "tasks",
      where: "id = $taskId",
    );

    return mapToTask(res.first);
  }

  Future<List> getAll() async {
    Database db = await database;

    List res = await db.query("tasks");

    return res.isEmpty ? [] : res.map((t) => mapToTask(t)).toList();
  }

  Future<void> update(Task t) async {
    Database db = await database;
    return await db.update(
      "tasks",
      taskToMap(t),
      where: "id = ${t.id}"
    );
  }

  Future<void> delete(Task t) async {
    Database db = await database;

    return await db.delete(
      "tasks",
      where: "id = ${t.id}"
    );
  }
}
