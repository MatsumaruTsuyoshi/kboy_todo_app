import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_model.dart';

class AddPage extends StatelessWidget {
  final MainModel model;
  AddPage(this.model);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>.value(
      value: model,
      child: Scaffold(
        appBar: AppBar(
          title: Text('new todo add'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      labelText: '追加するTodo', hintText: '例：夕飯の支度'),
                  onChanged: (text) {
                    model.todoText = text;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                MaterialButton(
                  child: Text('add'),
                  onPressed: () async {
                    await model.add();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
