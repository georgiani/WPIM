import 'package:pim/BaseModel.dart';

class Task {
  int id;
  String description;
  String due;
  String completed = "false";
}

class TasksModel extends BaseModel { }

TasksModel tasksModel = TasksModel();