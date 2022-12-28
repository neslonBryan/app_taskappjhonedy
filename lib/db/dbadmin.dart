import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_models.dart';

class DBAdmin {
  Database? myDatabase;

  static final DBAdmin db = DBAdmin._();
  DBAdmin._();

  Future<Database?> checkDatabase() async {
    if (myDatabase != null) {
      return myDatabase;
    }

    myDatabase = await initDatabase();
    return myDatabase;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "taskDB.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database dbx, int version) async {
        await dbx.execute(
          'CREATE TABLE task( id INTEGER PRIMARY KEY AUTOINCREMENT ,title TEXT , description TEXT , status TEXT)',
        );
      },
    );
  }

  Future<int> insertRawTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.rawInsert(
      "INSERT INTO task(title , description,status) VALUES ('${model.title}','${model.description}','${model.status}')",
    );
    return res;
  }

  Future<int> insertTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.insert(
      "task",
      {
        "title": model.title,
        "description": model.description,
        "status": model.status,
      },
    );
    return res;
  }

  getRawTasks() async {
    Database? db = await checkDatabase();
    List tasks = await db!.rawQuery("SELECT * FROM task");
    print(tasks);
  }

  Future<List<TaskModel>> getTasks() async {
    Database? db = await checkDatabase();
    List<Map<String, dynamic>> tasks = await db!.query("task");
    List<TaskModel> taskModelList =
        tasks.map((e) => TaskModel.deMapAModel(e)).toList();
    /*
    tasks.forEach((element) {
      TaskModel task = TaskModel.deMapAModel(element);
      taskModelList.add(task);
    });
    */

    return taskModelList;
  }

  updateRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.rawUpdate(
        "UPDATE task SET title='Ir de compras' , description='Comprar Comida',status='true' WHERE id=2 ");
    print(res);
  }

  updateTask() async {
    Database? db = await checkDatabase();
    int res = await db!.update(
        "task",
        {
          "title": "Ir al cine",
          "description": "Es el viernes en la tarde",
          "status": "false",
        },
        where: "ID=3");
  }

  deleteRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.rawDelete("DELETE FROM task WHERE id=2");
    print(res);
  }

  deleteTask() async {
    Database? db = await checkDatabase();
    int res = await db!.delete("task", where: "id=3");
    print(res);
  }
}
