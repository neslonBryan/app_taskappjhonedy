import 'package:flutter/material.dart';
import 'package:app_taskappjhonedy/widgets/myformwidget.dart';
import 'package:app_taskappjhonedy/models/task_models.dart';
import 'package:app_taskappjhonedy/db/dbadmin.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> getFullName() async {
    return "Juan Manuel";
  }

  showDialogForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyFormWidget();
      },
    ).then((value) {
      print("El formulario fue cerrado");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    DBAdmin.db.getRawTasks();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialogForm();
          },
          child: const Icon(Icons.add)),
      body: FutureBuilder(
        future: DBAdmin.db.getTasks(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            List<TaskModel> myTasks = snap.data;
            return ListView.builder(
              itemCount: myTasks.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(index.toString()),
                  //confirmDismiss: (DismissDirection direction) {

                  //},
                  child: ListTile(
                    title: Text(
                      myTasks[index].title,
                    ),
                    subtitle: Text(
                      myTasks[index].description,
                    ),
                    leading: Text(
                      myTasks[index].id.toString(),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
