import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NotesDBWorker.dart';
import 'NotesEntry.dart';
import 'NotesList.dart';
import 'NotesModel.dart' show NotesModel, notesModel;

class Notes extends StatelessWidget {
  // basic constructor which loads the data
  // into the list screen from the database
  Notes() {
    notesModel.loadData("notes", NotesDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NotesModel>(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
          builder: (BuildContext ctx, Widget child, NotesModel m) {
        return IndexedStack(
          index: m.stackIndex,
          children: [
            NotesList(),
            NotesEntry(),
          ],
        );
      }),
    );
  }
}
