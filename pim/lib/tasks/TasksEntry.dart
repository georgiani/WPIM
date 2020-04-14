import 'package:flutter/material.dart';
import 'package:pim/tasks/TasksDBWorker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'TasksModel.dart' show TasksModel, tasksModel;
import 'package:pim/utils.dart' as utils;

class TasksEntry extends StatelessWidget {
  final TextEditingController _descCont = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TasksEntry() {
    _descCont.addListener(() {
      tasksModel.entityBeingEdited.description = _descCont.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tasksModel.entityBeingEdited != null) {
      _descCont.text = tasksModel.entityBeingEdited.description;
    }

    return ScopedModel<TasksModel>(
      model: tasksModel,
      child: ScopedModelDescendant(
        builder: (BuildContext ctx, Widget child, TasksModel t) {
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                children: [
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      FocusScope.of(ctx).requestFocus(FocusNode()); // the focus
                      // is put on a new FocusNode, so the OS closes the keyboard
                      // if the app runs on a phone
                      tasksModel.setStackIndex(0);
                    },
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text("Save"),
                    onPressed: () {
                      _save(ctx);
                    },
                  ),
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.insert_drive_file),
                    title: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Task",
                      ),
                      controller: _descCont,
                      validator: (String s) {
                        if (s.length == null) {
                          return "Insert a task";
                        }

                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.today),
                    title: Text("Due Date"),
                    subtitle: Text(tasksModel.chosenDate == null
                        ? ""
                        : tasksModel.chosenDate),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () async {
                        String chosenDate = await utils.selectDate(ctx, tasksModel, tasksModel.entityBeingEdited.due);
                        if (chosenDate != null) {
                          tasksModel.entityBeingEdited.due = chosenDate;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _save(BuildContext ctx) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (tasksModel.entityBeingEdited.id == null) {
      await TasksDBWorker.db.create(tasksModel.entityBeingEdited);
    } else {
      await TasksDBWorker.db.update(tasksModel.entityBeingEdited);
    }

    tasksModel.loadData("notes", TasksDBWorker.db);
    tasksModel.setStackIndex(0);

    Scaffold.of(ctx).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Task saved")));
  }
}
