import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqloctober/student.dart';

class MyDbHelper{
  late Database _database;
  Future<void> initdb() async {
    _database=await openDatabase
      (
      join(await getDatabasesPath(),"mydatabase.db"),
      version: 1,
      onCreate: (Database db,int version)
      {
        db.execute("CREATE TABLE studenttable(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,phone TEXT)");
      }
      );
  }

  Future<int> insertStudent(Student s) async {
    await initdb();
    return await _database.insert("studenttable", s.tomap());
  }
  Future<int> updateStudent(Student s) async {
    await initdb();
    return await _database.update("studenttable", s.tomap(),where: "id=?",whereArgs: [s.id]);
  }
  Future<int> deleteStudent(Student s) async {
    await initdb();
    return await _database.delete("studenttable", where: "id=?",whereArgs: [s.id]);
  }
  Future<List<Map<String,dynamic>>> getallStudents() async {
    await initdb();
    var list=await _database.query("studenttable");
    return list;
  }
}