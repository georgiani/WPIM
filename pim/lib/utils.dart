import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'BaseModel.dart';

//used before the start of the app
Directory docsDir;

Future selectDate(BuildContext ctx, BaseModel model, String date) async {
  DateTime init = DateTime.now();

  if (date != null) {
    List dateFields = date.split(',');
    // field 0 is year, field 1 is month, field 2 if day
    init = DateTime(
      int.parse(dateFields[0]),
      int.parse(dateFields[1]),
      int.parse(dateFields[2]),
    );
  }

  // show a date picker screen and let the user choose a date'
  DateTime picked = await showDatePicker(
      context: ctx,
      initialDate: init,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  // check if the user pressed "Cancel"
  if (picked != null) {
    model.setChosenDate(DateFormat.yMMMMd("en_US").format(picked.toLocal()));
    return "${picked.year},${picked.month},${picked.day}";
  }
}
