import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/controller/todo_controller.dart';

void main() {
  test('1. At first there should be no todo', () {
    final todoController = TodoController();
    expect(todoController.todos.isEmpty, true);
  });

  test('2. Adding task should have a task', () {
    final todoController = TodoController();
    expect(todoController.todos.isEmpty, true);

    todoController.addTask('Cook dinner', DateTime.now());
    expect(todoController.todos.length, 1);
    expect(todoController.todos[0].title, 'Cook dinner');
    expect(todoController.todos[0].deadline.day, 9);
    expect(todoController.todos[0].deadline.month, 10);
    expect(todoController.todos[0].deadline.year, 2026);
  });
}