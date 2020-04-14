import 'package:flutter/material.dart';
import 'package:pim/tasks/TasksDBWorker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'TasksEntry.dart';
import 'TasksList.dart';
import 'TasksModel.dart' show TasksModel, tasksModel;
import 'package:pim/tasks/TasksModel.dart';

class Tasks extends StatelessWidget {

  Tasks() {
    tasksModel.loadData("tasks", TasksDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TasksModel> (
      model: tasksModel,
      child: ScopedModelDescendant<TasksModel>(
        builder: (BuildContext ctx, Widget child, TasksModel t) {
          return IndexedStack(
            index: t.stackIndex,
            children: [
              TasksList(),
              TasksEntry(),
            ],
          );
        },
      ),
    );
  }
}