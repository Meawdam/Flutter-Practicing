import 'package:flutter/material.dart';

class TodoEditView extends StatelessWidget {
  String title;
  final textController = TextEditingController();
  TodoEditView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    textController.text = title;

    return Scaffold(
      appBar: AppBar(title: Text('Edit task'),),
      body: Row(
        children: [
          Expanded(child: TextField(controller: textController,)),
          FilledButton(onPressed: () {
            String newTitle = textController.text.trim();
            Navigator.pop(context, newTitle);
          }, child: Text('Update'))
        ],
      ),
    );
  }
}