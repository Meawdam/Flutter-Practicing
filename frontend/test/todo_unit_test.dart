import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/controller/todo_controller.dart';
import 'package:frontend/model/todo_model.dart';

void main() {
  test('1. Fetch tasks should return all tasks', () async {
    final todoController = TodoController();
    List<TodoModel> todos = await todoController.fetchTask(); 
    expect(todos.isNotEmpty, true);
    expect(todos.first.title, 'Do homework');
    expect(todos.first.complete, false);
    expect(todos.first.favorite, false);
  });
}