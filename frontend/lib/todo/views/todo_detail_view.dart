import 'package:flutter/material.dart';
import 'package:frontend/todo/model/todo_model.dart';

class TodoDetailView extends StatelessWidget {
 final TodoModel task;
 const TodoDetailView({super.key, required this.task});


 @override
 Widget build(BuildContext context) {
   String deadline =
       '${task.deadline.day}/${task.deadline.month}/${task.deadline.year}';
   return Scaffold(
     appBar: AppBar(title: Text('Task Detail')),
     body: Card(
       margin: EdgeInsets.symmetric(horizontal: 16),
       child: Padding(
         padding: const EdgeInsets.all(16),
         child: Column(
           crossAxisAlignment: .start,
           mainAxisSize: .min,
           children: [
             Text('Task title: ${task.title}'),
             Text('Deadline: $deadline'),
             Text('Complete: ${task.complete == 1 ? "yes" : "no"}'),
             Text('Favorite: ${task.favorite == 1 ? "yes" : "no"}'),
           ],
         ),
       ),
     ),
   );
 }
}

