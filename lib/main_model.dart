import 'package:firebase_todo_app/todo.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainModel extends ChangeNotifier {
  List<Todo> todoList = [];
  String todoText = '';

  Future getTodoList() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('todoList').get();
    final docs = snapshot.docs;
    final todoList = docs.map((doc) => Todo(doc)).toList();
    this.todoList = todoList;
    notifyListeners();
  }

  void getTodoListRealTime() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final snapshots = firestore.collection('todoList').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final todoList = docs.map((doc) => Todo(doc)).toList();
      todoList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      this.todoList = todoList;
      notifyListeners();
    });
  }

  Future add() async {
    final collection = FirebaseFirestore.instance.collection('todoList');
    await collection.add({
      'title': todoText,
      'createdAt': Timestamp.now(),
    });
  }

  Future reload() async {
    notifyListeners();
  }

  Future deleteCheckedItems() async {
    final checkedItems = todoList.where((todo) => todo.isDone).toList();
    final references =
        checkedItems.map((todo) => todo.documentReference).toList();

    final batch = FirebaseFirestore.instance.batch();
    references.forEach((reference) {
      batch.delete(reference);
    });

    return batch.commit();
  }

  bool checkShouldActiveCompleteButton() {
    final checkedItems = todoList.where((todo) => todo.isDone).toList();
    return checkedItems.length > 0;
  }
}
