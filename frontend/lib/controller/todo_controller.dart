import 'package:frontend/model/todo_model.dart';

class TodoController {
  List<TodoModel> todos = [];

  void addTask(String title, DateTime deadline) {
    // create task
    final task = TodoModel(title: title, deadline: deadline);
    // add task to list
    todos.add(task);
  }
}
