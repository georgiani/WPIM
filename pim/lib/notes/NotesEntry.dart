import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show NotesModel, notesModel;

class NotesEntry extends StatelessWidget {

  final TextEditingController _titleCont = TextEditingController();
  final TextEditingController _contentCont = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 

  NotesEntry() {
    _titleCont.addListener(() {
      notesModel.entityBeingEdited.title = _titleCont.text;
    });

    _contentCont.addListener(() {
      notesModel.entityBeingEdited.content = _contentCont.text;
    });
  }

  Future _save(BuildContext ctx, NotesModel n) async {

  }

  @override
  Widget build(BuildContext context) {
    _titleCont.text = notesModel.entityBeingEdited.title;
    _contentCont.text = notesModel.entityBeingEdited.content;

    return ScopedModel<NotesModel> (
      model: notesModel,
      child: ScopedModelDescendant(
        builder: (BuildContext ctx, Widget w, NotesModel m) {
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
                      m.setStackIndex(0);
                    },
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text("Save"),
                    onPressed: () {
                      _save(ctx, notesModel);
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
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Title",
                      ),
                      controller: _titleCont,
                      validator: (String s) {
                        if (s.length == 0) {
                          return "Please enter a title";
                        }

                        return null;
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
}