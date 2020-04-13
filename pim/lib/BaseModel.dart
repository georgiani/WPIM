import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model {
  // 0 for the list screen and
  // 1 for the entry screen
  int stackIndex = 0; 

  // the list of data to show
  // on the entity list screen
  List entityList = [];

  // keeps track of what type of
  // entry is added or edited
  var entityBeingEdited;

  // the date chosen in selectDate.
  // It is here because
  // it is used by most
  // of the four types of entity
  String chosenDate;

  // this is used in the selectDate function
  // from utils.dart. The date is in the MONTH dd, yyyy format
  void setChosenDate (String date) {
    chosenDate = date;
    notifyListeners();
  }

  // this is called whenever an entity is added or
  // removed from the entityList
  void loadData (String entityType, dynamic db) async {
    entityList = await db.getAll();
    notifyListeners();
  }

  // change between list and entry screen
  void setStackIndex (int stackIndex) {
    this.stackIndex = stackIndex;
    notifyListeners();
  }
}