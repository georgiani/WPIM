import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pim/tasks/TasksDBWorker.dart';
import 'package:pim/tasks/TasksModel.dart';
import 'package:scoped_model/scoped_model.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<TasksModel>(
      model: tasksModel,
      child: ScopedModelDescendant(
        builder: (BuildContext ctx, Widget child, TasksModel t) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                t.entityBeingEdited = Task();
                t.setStackIndex(1);
              },
            ),
            body: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              itemCount: t.entityList.length,
              itemBuilder: (BuildContext context, int idx) {
                Task task = t.entityList[idx];
                String sdueDate;
                if (task.due != null) {
                  List dateParts = task.due.split(",");
                  DateTime dueDate = DateTime(
                    int.parse(dateParts[0]),
                    int.parse(dateParts[1]),
                    int.parse(dateParts[2]),
                  );

                  sdueDate =
                      DateFormat.yMMMMd("en_US").format(dueDate.toLocal());

                  return Slidable(
                    delegate: SlidableDrawerDelegate(),
                    actionExtentRatio: .25,
                    child: ListTile(
                      leading: Checkbox(
                        value: task.completed == "true" ? true : false,
                        onChanged: (val) async {
                          task.completed = val.toString();
                          await TasksDBWorker.db.update(task);
                          t.loadData("tasks", TasksDBWorker.db);
                        },
                      ),
                      title: Text(
                        "${task.description}",
                        style: task.completed == "true"
                            ? TextStyle(
                                color: Theme.of(ctx).disabledColor,
                                decoration: TextDecoration.lineThrough,
                              )
                            : TextStyle(
                                color: Theme.of(ctx).textTheme.headline6.color,
                              ),
                      ),
                      subtitle: task.due == null
                          ? null
                          : Text(
                              sdueDate,
                              style: task.completed == "true"
                                  ? TextStyle(
                                      color: Theme.of(ctx).disabledColor,
                                      decoration: TextDecoration.lineThrough,
                                    )
                                  : TextStyle(
                                      color: Theme.of(ctx)
                                          .textTheme
                                          .headline6
                                          .color,
                                    ),
                            ),
                      onTap: () async {
                        if (task.completed == "true") {
                          return;
                        }
                        t.entityBeingEdited = await TasksDBWorker.db.get(task.id);

                        if (t.entityBeingEdited.due == null) {
                          t.setChosenDate(null);
                        } else {
                          t.setChosenDate(sdueDate);
                        }

                        t.setStackIndex(1);
                      },
                    ),
                    secondaryActions: [
                      IconSlideAction(
                        caption: "Delete",
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => _deleteTask(ctx, task),
                      ),
                    ],
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Future _deleteTask(BuildContext ctx, Task task) {
      return showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Are you sure you want to delete this?"),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(alertContext).pop();
              },
            ),
            FlatButton(
              child: Text("Delete"),
              onPressed: () async {
                await TasksDBWorker.db.delete(task);

                Navigator.of(alertContext).pop();
                Scaffold.of(ctx).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    content: Text("Task deleted"),
                  ),
                );

                tasksModel.loadData("tasks", TasksDBWorker.db);
              },
            ),
          ],
        );
      }
    );
  }
}
