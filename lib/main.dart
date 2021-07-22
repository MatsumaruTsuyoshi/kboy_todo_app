import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_todo_app/add/add_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOアプリ',
      home: Main(),
    );
  }
}

class Main extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..getTodoListRealTime(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Todo'),
          actions: [
            Consumer<MainModel>(builder: (context, model, child) {
              final isActive = model.checkShouldActiveCompleteButton();
              return MaterialButton(
                child: Text(
                  'complete',
                  style: TextStyle(
                    color:
                        isActive ? Colors.white : Colors.white.withOpacity(0.5),
                  ),
                ),
                onPressed: isActive
                    ? () async {
                        await model.deleteCheckedItems();
                      }
                    : null,
              );
            })
          ],
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          final todoList = model.todoList;
          return ListView(
              children: todoList
                  .map(
                    (todo) => CheckboxListTile(
                      title: Text(todo.title),
                      value: todo.isDone,
                      onChanged: (bool value) {
                        todo.isDone = !todo.isDone;
                        model.reload();
                      },
                    ),
                  )
                  .toList());
        }),
        floatingActionButton:
            Consumer<MainModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPage(model),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Icon(Icons.add),
          );
        }),
      ),
    );
  }
}
