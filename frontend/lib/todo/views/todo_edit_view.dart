import 'package:flutter/material.dart';
import 'package:frontend/todo/model/todo_model.dart';

class TodoEditView extends StatelessWidget {
 final TodoModel task;
 final editController = TextEditingController();
 TodoEditView({super.key, required this.task});


 @override
 Widget build(BuildContext context) {
   // show the current task title
   editController.text = task.title;


   return Scaffold(
     appBar: AppBar(title: Text('Edit Task')),
     body: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 16),
       child: Row(
         children: [
           Expanded(child: TextField(controller: editController)),
           SizedBox(width: 8),
           FilledButton(
             onPressed: () {
               String editText = editController.text.trim();
               if (editText.isEmpty) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('Error: Invalid input')),
                 );
                 return;
               }
               // return to the previous page
               Navigator.pop(context, editText);
             },
             child: Text('Confirm'),
           ),
           SizedBox(width: 4),
           FilledButton(
             style: FilledButton.styleFrom(backgroundColor: Colors.red),
             onPressed: () {
               Navigator.pop(context);
             },
             child: Text('Cancel'),
           ),
         ],
       ),
     ),
   );
 }
}

