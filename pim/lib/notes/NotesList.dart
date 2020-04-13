import 'package:flutter/material.dart';
import 'package:pim/notes/Notes.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show Note, NotesModel, notesModel;

class NotesList extends StatelessWidget {

  Future _deleteNote(BuildContext ctx, Note n) {
    return showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text("Delete Note"),
          content: Text("Are you sure you want to delete ${n.title}?"),
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
                await NotesDBWorker.db.delete(n);

                Navigator.of(alertContext).pop();
                Scaffold.of(ctx).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    content: Text("Note deleted"),
                  ),
                );

                notesModel.loadData("notes", NotesDBWorker.db);
              },
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NotesModel>(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
        builder: (BuildContext ctx, Widget child, NotesModel model) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                notesModel.entityBeingEdited = Note();
                notesModel.setColor(null);
                notesModel.setStackIndex(1);
              },
            ),
            body: ListView.builder(
              itemCount: notesModel.entityList.length,
              itemBuilder: (BuildContext ctx, int idx) {
                Note note = notesModel.entityList[idx];
                Color color = Colors.white;

                switch (note.color) {
                  case "red":
                    color = Colors.red;
                    break;
                  case "green":
                    color = Colors.green;
                    break;
                  case "blue":
                    color = Colors.blue;
                    break;
                  case "yellow":
                    color = Colors.yellow;
                    break;
                  case "grey":
                    color = Colors.grey;
                    break;
                  case "purple":
                    color = Colors.purple;
                    break;
                }

                return Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Slidable(
                    delegate: SlidableDrawerDelegate(), // controls how it animates
                    actionExtentRatio: .25, // 25% to the left
                    secondaryActions: [ // actions if sliding left
                      IconSlideAction(
                        caption: "Delete",
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => _deleteNote(ctx, note),
                      ),
                    ],
                    child: Card(
                      elevation: 8,
                      color: color,
                      child: ListTile(
                        title: Text("${note.title}"),
                        subtitle: Text("${note.content}"),
                        onTap: () async {
                          notesModel.entityBeingEdited = await NotesDBWorker.db.get(note.id);
                          notesModel.setColor(notesModel.entityBeingEdited.color);
                          notesModel.setStackIndex(1);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
