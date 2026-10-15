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

  test('2. add task should have new task', () async {
    final todoController = TodoController();
    List<TodoModel> todos = await todoController.fetchTask();
    int before = todos.length;

    await todoController.addTask('Sleep early', DateTime(2026, 10, 15));
    todos = await todoController.fetchTask();
    expect(todos.length, before + 1);
    expect(todos.last.title, 'Sleep early');
    expect(todos.last.deadline.year, 2026);
  });

    test('3. edit task title should be changed', () async {
    final todoController = TodoController();
    List<TodoModel> todos = await todoController.fetchTask();

    await todoController.editTask('1', 'Shower');
    todos = await todoController.fetchTask();
    expect(todos.first.title, 'Shower');
  });
}
