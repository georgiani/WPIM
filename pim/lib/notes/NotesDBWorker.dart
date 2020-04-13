import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pim/utils.dart' as utils;
import 'NotesModel.dart';

// there is always a single instance of
// this so i'm implementing a singleton pattern
// that consists of a private constructor _()
// and a static variable db
// so the db variable is always accesible by NotesDBWorker.db
// and it's impossible to create another instance of this
class NotesDBWorker {
  NotesDBWorker._();
  static final NotesDBWorker db = NotesDBWorker._();

  Database _db;

  Future get database async {
    // if there isn't already an instance
    // of the database, i init one
    if (_db == null) {
      _db = await init();
    }
    // else i return the existing one
    return _db;
  }

  // init function returns a database
  // to the _db if there is not already an instantiated one
  Future<Database> init() async {
    // the path to the table file
    String path = join(utils.docsDir.path, "notes.db");

    // i open a new database
    Database db = await openDatabase(
      path, // from its path
      version: 1, // version used if it's needed to update the schema
      onOpen: (db) {}, // i am creating one not opening one
      onCreate: (Database newDb, int v) async {
        // query to create a new database
        await newDb.execute("CREATE TABLE IF NOT EXISTS notes ("
            "id INTEGER PRIMARY KEY,"
            "title TEXT,"
            "content TEXT,"
            "color TEXT"
            ")");
      },
    );

    return db;
  }

  // helper functions because the database
  // works with maps
  Note mapToNote(Map m) {
    Note n = Note();
    n.id = m["id"];
    n.title = m["title"];
    n.content = m["content"];
    n.color = m["color"];

    return n;
  }

  Map<String, dynamic> noteToMap(Note n) {
    Map<String, dynamic> m = Map<String, dynamic>();
    m["id"] = n.id;
    m["title"] = n.title;
    m["content"] = n.content;
    m["color"] = n.color;

    return m;
  }

  Future create(Note n) async {
    // get a reference to the database
    // through the getter
    Database db = await database;

    // query for the last entry and get id + 1
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM notes");

    int id = val.first["id"]; // getting the id + 1
    if (id == null) {
      // if there are no entries
      id = 1; // then this will be the first one
    }

    // make an insert query to the database
    // with the note passed as argument
    // return await db.rawInsert(
    //   "INSERT INTO notes (id, title, content, color)"
    //   "VALUES (?, ?, ?, ?)", // ? will be swapped with the values from array
    //   [id, n.title, n.content, n.color],
    // );

    // this is an alternative
    return await db.insert("notes", noteToMap(n));
  }

  Future<Note> get(int id) async {
    Database db = await database;

    var res = await db.query(
      "notes",
      where: "id = ?", // or "id = $id"
      whereArgs: [id],
    );

    return mapToNote(res.first);
  }

  Future<List> getAll() async {
    Database db = await database;

    var res = await db.query(
      "notes",
    );

    // if the result of the query
    // is empty then we return an empty list
    // else we map all the values from the results
    // to their Note and the turn everything to a list
    return res.isEmpty ? [] : res.map((m) => mapToNote(m)).toList();
  }

  Future update(Note n) async {
    Database db = await database;

    return await db.update(
      "notes",
      noteToMap(n),
      where: "id = ${n.id}",
    );
  }

  Future delete(Note n) async {
    Database db = await database;

    return await db.delete(
      "notes",
      where: "id = ${n.id}",
    );
  }
}
