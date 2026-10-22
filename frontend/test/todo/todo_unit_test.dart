import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/todo/controller/todo_controller.dart';
import 'package:frontend/todo/model/todo_model.dart';

void main() {
  late TodoController todoController;

  setUp(() {
    todoController = TodoController();
  });
  test('1. Fetch todo should return Todo list', () async {
    List<TodoModel> todos = await todoController.fetchTasks();
    expect(todos.length, 3);
    expect(todos[1].title, 'Cook Dinner');
  });

  test('2. Add new task should have new task', () async {
    List<TodoModel> todos = await todoController.fetchTasks();
    int before = todos.length;

    await todoController.addTask('Read a book', DateTime(2026, 9, 13));

    todos = await todoController.fetchTasks();

    expect(todos.length, before + 1);
    expect(todos.last.title, 'Read a book');
    expect(todos.last.deadline.day, 13);
  });

  test('3. Delete task, the task should be deleted', () async {
    List<TodoModel> todos = await todoController.fetchTasks();
    int before = todos.length;

    await todoController.deleteTask(todos.last.id);

    todos = await todoController.fetchTasks();

    expect(todos.length, before - 1);
  });

  test('4. Update title, the title should be updated', () async {
    List<TodoModel> todos = await todoController.fetchTasks();
    expect(todos[0].title, 'Do homework');

    await todoController.updateTask('1', 'Take a shower');

    todos = await todoController.fetchTasks();

    expect(todos[0].title, 'Take a shower');
  });
}
