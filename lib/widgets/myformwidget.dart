import 'package:flutter/material.dart';

import 'package:app_taskappjhonedy/models/task_models.dart';
import 'package:app_taskappjhonedy/db/dbadmin.dart';

class MyFormWidget extends StatefulWidget {
  const MyFormWidget({super.key});

  @override
  State<MyFormWidget> createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool isfinished = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  addTask() {
    if (_formKey.currentState!.validate()) {
      TaskModel taskModel = TaskModel(
        title: _titleController.text,
        description: _descriptionController.text,
        status: isfinished.toString(),
      );
      DBAdmin.db.insertTask(taskModel).then((value) {
        if (value > 0) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.purple[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              duration: const Duration(milliseconds: 1400),
              content: Row(
                children: const [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text("Tarea realizada con exito"),
                ],
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Agregar tarea"),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "El campo es obligatorio";
                }
                return null;
              },
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Titulo",
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "El campo es obligatorio";
                }
                return null;
              },
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Descripcion",
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Text("Estado: "),
                SizedBox(
                  height: 8.0,
                ),
                Checkbox(
                  value: isfinished,
                  onChanged: (value) {
                    isfinished = value!;
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"),
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    addTask();
                  },
                  child: Text("Aceptar"),
                ),
              ],
            )
          ],
        ),
      ),
    );
    ;
  }
}
