import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/todo/controller/todo_controller.dart';
import 'package:frontend/todo/model/todo_model.dart';

void main() {
  test('1. Get tasks should return all tasks', () async {
    TodoController controller = TodoController();
    List<TodoModel> todos = await controller.getTasks();

    expect(todos.length, 2);
    expect(todos.first.title, 'Cook dinner');
    expect(todos.first.deadline.day, 25);
  });

  test('2. Add new task should have the new task', () async {
    TodoController controller = TodoController();
    List<TodoModel> todos = await controller.getTasks();
    int before = todos.length;

    await controller.addTask('Watch movie', DateTime(2026, 10, 22));
    todos = await controller.getTasks();

    expect(todos.length, before + 1);
    expect(todos.last.title, 'Watch movie');
    expect(todos.last.deadline.day, 22);
  });

  test('3. Delete task should remove the task', () async {
    TodoController controller = TodoController();
    List<TodoModel> todos = await controller.getTasks();
    int before = todos.length;

    // delete the last task
    await controller.deleteTask(todos.last.id);
    todos = await controller.getTasks();

    expect(todos.length, before - 1);
  });

  test('4. Edit task should have the updated task', () async {
    TodoController controller = TodoController();
    List<TodoModel> todos = await controller.getTasks();

    // update the first task
    await controller.editTask(todos.first.id, 'Cook dinner');
    todos = await controller.getTasks();

    expect(todos.first.title, 'Cook dinner');
  });

  test('5. Toggle status should have the updated status', () async {
    TodoController controller = TodoController();
    List<TodoModel> todos = await controller.getTasks();
    int complete = todos.first.complete;
    int favorite = todos.first.favorite;

    // update the first status
    await controller.toggleTask(todos.first.id, 'complete', 1 - complete);
    await controller.toggleTask(todos.first.id, 'favorite', 1 - favorite);
    todos = await controller.getTasks();

    expect(todos.first.complete, 1 - complete);
    expect(todos.first.favorite, 1 - favorite);
  });

  test('6. Search tasks should return titles matching the query', () {
    final todos = [
      TodoModel(id: 1, title: 'Cook lunch', deadline: DateTime(2026, 10, 31)),
      TodoModel(id: 2, title: 'Clean room', deadline: DateTime(2026, 12, 31)),
    ];

    final results = TodoController.filterTasks(todos, '  LUNCH  ');

    expect(results.length, 1);
    expect(results.first.title, 'Cook lunch');
  });
}
