import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show NotesModel, notesModel;
import 'NotesModel.dart';

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

  void _save(BuildContext ctx, NotesModel n) async {
    if (!_formKey.currentState.validate()) { return; }

    if (n.entityBeingEdited.id == null) {
      await NotesDBWorker.db.create(n.entityBeingEdited);
    } else {
      await NotesDBWorker.db.update(notesModel.entityBeingEdited);
    }

    notesModel.loadData("notes", NotesDBWorker.db);
    notesModel.setStackIndex(0);

    Scaffold.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor : Colors.green,
        duration : Duration(seconds : 2),
        content : Text("Note saved")
      )
    );

  } 

  @override
  Widget build(BuildContext context) {
    if (notesModel.entityBeingEdited != null) {
      _titleCont.text = notesModel.entityBeingEdited.title;
      _contentCont.text = notesModel.entityBeingEdited.content;
    }

    return ScopedModel<NotesModel>(
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
                      notesModel.setStackIndex(0);
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
                  ListTile(
                    leading : Icon(Icons.content_paste),
                    title : TextFormField(
                      keyboardType : TextInputType.multiline, maxLines : 8,
                      decoration : InputDecoration(hintText : "Content"),
                      controller : _contentCont,
                      validator : (String inValue) {
                        if (inValue.length == 0) { return "Please enter content"; }
                        return null;
                      }
                    )
                  ),
                  // Note color.
                  ListTile(
                    leading : Icon(Icons.color_lens),
                    title : Row(
                      children : [
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.red, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "red" ? Colors.red : Theme.of(ctx).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "red";
                            notesModel.setColor("red");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.green, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "green" ? Colors.green : Theme.of(ctx).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "green";
                            notesModel.setColor("green");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.blue, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "blue" ? Colors.blue : Theme.of(ctx).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "blue";
                            notesModel.setColor("blue");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.yellow, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "yellow" ? Colors.yellow : Theme.of(ctx).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "yellow";
                            notesModel.setColor("yellow");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.grey, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "grey" ? Colors.grey : Theme.of(ctx).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "grey";
                            notesModel.setColor("grey");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.purple, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "purple" ? Colors.purple : Theme.of(ctx).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "purple";
                            notesModel.setColor("purple");
                          }
                        )
                      ]
                    )
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
