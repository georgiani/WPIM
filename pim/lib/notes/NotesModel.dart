import 'package:pim/BaseModel.dart';

class Note {
  int id;
  String title;
  String content;
  String color;

  // used for debugging purposes
  String toString() {
    return "{id = $id, title = $title, content = $content, color = $color}";
  }
}

class NotesModel extends BaseModel {
  String color;

  // the user can choose a color
  // when creating a new note
  void setColor(String color) {
    this.color = color;
    notifyListeners();
  }
}

NotesModel notesModel = NotesModel();