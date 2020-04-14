import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'notes/Notes.dart';
import 'tasks/Tasks.dart';
import 'utils.dart' as utils;
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  startMeUp() async {
    Directory docsDir;
    if (kIsWeb) {
      docsDir = Directory("lib/db");
    } else if (Platform.isMacOS) {
      docsDir = Directory("lib/db");
    } else {
      docsDir = await getApplicationDocumentsDirectory();
    }
    utils.docsDir = docsDir;
    runApp(WPIM());
  }

  startMeUp();
}

class WPIM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WPIM",
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.orange,
          appBar: AppBar(
            title: Text("WPIM"),
            backgroundColor: Colors.orangeAccent,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.note),
                  text: "Notes",
                ),
                Tab(
                  icon: Icon(Icons.assignment_turned_in),
                  text: "Tasks",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Notes(),
              Tasks(),
            ],
          ),
        ),
      ),
    );
  }
}