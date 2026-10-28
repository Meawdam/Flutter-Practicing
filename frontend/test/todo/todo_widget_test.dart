// to test only the tests with the specified tags
// flutter test test/widget_test_todo.dart -t "yes" --reporter=expanded
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/todo/controller/todo_controller.dart';
import 'package:frontend/todo/model/todo_model.dart';
import 'package:frontend/todo/views/todo_detail_view.dart';
import 'package:frontend/todo/views/todo_edit_view.dart';
import 'package:frontend/todo/views/todo_view.dart';
import 'package:mocktail/mocktail.dart';

// Create a Mock class for TodoController
class MockTodoController extends Mock implements TodoController {}

void main() {
  late MockTodoController mockTodoController;

  setUp(() {
    mockTodoController = MockTodoController();
  });

  group('Todo App Widget Tests', () {
    testWidgets('1. At first, spinner and existing tasks should be shown.', (
      WidgetTester tester,
    ) async {
      // Arrange
      final mockTodos = [
        TodoModel(
          id: 1,
          title: 'Test Task 1',
          deadline: DateTime(2026, 10, 31),
          complete: 0,
          favorite: 1,
        ),
        TodoModel(
          id: 2,
          title: 'Test Task 2',
          deadline: DateTime(2026, 12, 31),
          complete: 1,
          favorite: 0,
        ),
      ];

      // Define getTasks method to return our mock list
      when(() => mockTodoController.getTasks())
          .thenAnswer((_) async => mockTodos);

      // Load App
      await tester.pumpWidget(TodoView(todoController: mockTodoController));

      // Initially shows loading indicator
      expect(find.byType(CircularProgressIndicator), findsOne);

      // Wait for the FutureBuilder to complete and rebuild
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Task 1'), findsOne);
      expect(find.text('Test Task 2'), findsOne);
      // verify(() => mockTodoController.getTasks()).called(1);
    });

    testWidgets('2. Shows error SnackBar when trying to add empty task', (
      WidgetTester tester,
    ) async {
      // Define getTask result
      when(() => mockTodoController.getTasks()).thenAnswer((_) async => []);

      await tester.pumpWidget(TodoView(todoController: mockTodoController));
      await tester.pumpAndSettle();

      // Act: Tap Add without entering text
      await tester.tap(find.widgetWithText(FilledButton, 'Add'));
      await tester.pump(); // Pump to show SnackBar

      // Assert
      expect(find.byType(SnackBar), findsOne);
      expect(find.text('Error: No input'), findsOne);
      // verifyNever(() => mockTodoController.addTask(any(), any()));
    });

    testWidgets(
      '3. Adds a new task with valid input should show the added task',
      (WidgetTester tester) async {
        // Define what fetchTask should do when called: return an empty list
        when(() => mockTodoController.getTasks()).thenAnswer((_) async => []);

        // load page, in the code, it will getTask
        await tester.pumpWidget(TodoView(todoController: mockTodoController));
        await tester.pumpAndSettle();

        // mock the added data
        final addedTask = TodoModel(
          id: 5,
          title: 'Buy Groceries',
          deadline: DateTime(2026, 12, 31),
        );

        // Define mocked addTask() => return nothing, because the UI will call fetchTasks() afterward
        when(() => mockTodoController.addTask(any(), any()))
            .thenAnswer((_) async => {});
        // Define new mocked fetchTasks() => return List with newly added task
        when(() => mockTodoController.getTasks())
            .thenAnswer((_) async => [addedTask]);

        // Act: Enter the task title into the TextField and tap 'Add'
        await tester.enterText(find.byType(TextField).last, 'Buy Groceries');
        await tester.tap(find.widgetWithText(FilledButton, 'Add'));
        await tester.pumpAndSettle();

        expect(find.text('Buy Groceries'), findsOne);
      },
    );

    testWidgets('4. Delete task should have not that task anymore', (
      WidgetTester tester,
    ) async {
      // Arrange
      final mockTodos = [
        TodoModel(
          id: 123,
          title: 'Task to Delete',
          deadline: DateTime(2026, 12, 31),
        ),
      ];

      // Define what will happen if call the methods
      when(() => mockTodoController.getTasks())
          .thenAnswer((_) async => mockTodos);
      // load app
      await tester.pumpWidget(TodoView(todoController: mockTodoController));
      await tester.pumpAndSettle();

      // delete should do nothing
      when(() => mockTodoController.deleteTask(123))
          .thenAnswer((_) async => {});
      // after deleting, fetchTasks will be called, the List member should be gone
      when(() => mockTodoController.getTasks()).thenAnswer((_) async => []);

      // Act: Tap the delete icon
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Task to Delete'), findsNothing);
      // verify(() => mockTodoController.deleteTask('123')).called(1);
    });

    testWidgets('5. Toggle task favorite should change the favorite status', (
      WidgetTester tester,
    ) async {
      // Arrange
      final mockTodos = [
        TodoModel(
          id: 123,
          title: 'Task to Toggle',
          deadline: DateTime(2026, 12, 31),
          favorite: 0,
        ),
      ];

      // Define what will happen if call the methods
      when(() => mockTodoController.getTasks())
          .thenAnswer((_) async => mockTodos);
      // load app
      await tester.pumpWidget(TodoView(todoController: mockTodoController));
      await tester.pumpAndSettle();

      // toggle favorite
      when(() => mockTodoController.toggleTask(123, 'favorite', 0))
          .thenAnswer((_) async => {});
      // after toggling, fetchTasks will be called, the item favorite should be toggled
      mockTodos.first.favorite = 1;
      when(() => mockTodoController.getTasks())
          .thenAnswer((_) async => mockTodos);

      // Act: Tap the fav icon
      await tester.tap(find.byIcon(Icons.star));
      await tester.pumpAndSettle();

      // Assert
      final Finder iconButtonFinder = find.byWidgetPredicate((Widget widget) {
        return widget is IconButton &&
            widget.icon is Icon &&
            (widget.icon as Icon).icon == Icons.star &&
            widget.color == Colors.amber;
      });
      expect(iconButtonFinder, findsOne);
      // verify(() => mockTodoController.deleteTask('123')).called(1);
    });

    testWidgets('6. Toggle task complete should change the complete status', (
      WidgetTester tester,
    ) async {
      // Arrange
      final mockTodos = [
        TodoModel(
          id: 123,
          title: 'Task to Complete',
          deadline: DateTime(2026, 12, 31),
          complete: 0,
        ),
      ];

      // Define what will happen if call the methods
      when(() => mockTodoController.getTasks())
          .thenAnswer((_) async => mockTodos);
      // load app
      await tester.pumpWidget(TodoView(todoController: mockTodoController));
      await tester.pumpAndSettle();

      // toggle should do nothing
      when(() => mockTodoController.toggleTask(123, 'complete', 0))
          .thenAnswer((_) async => {});
      // after toggling, fetchTasks will be called, the item complete status should be toggled
      mockTodos.first.complete = 1;
      when(() => mockTodoController.getTasks())
          .thenAnswer((_) async => mockTodos);

      // Act: Tap the ListTile
      await tester.tap(find.text('Task to Complete'));
      await tester.pumpAndSettle();

      // Assert
      Finder taskFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data == 'Task to Complete' &&
            widget.style?.decoration == TextDecoration.lineThrough,
      );
      expect(taskFinder, findsOne);
      // verify(() => mockTodoController.deleteTask('123')).called(1);
    });

    testWidgets('7. Tap the detail icon should show the task details', (
      WidgetTester tester,
    ) async {
      // mock the original data
      final mockTask = TodoModel(
        id: 5,
        title: 'Buy Groceries',
        deadline: DateTime(2026, 12, 31),
      );

      // Define what fetchTask should do when called: return an empty list
      when(() => mockTodoController.getTasks())
          .thenAnswer((_) async => [mockTask]);

      // load page, in the code, it will call getTask
      await tester.pumpWidget(TodoView(todoController: mockTodoController));
      await tester.pumpAndSettle();

      // Click detail icon to forward to the detail page
      await tester.tap(find.byIcon(Icons.zoom_in));
      await tester.pumpAndSettle();

      // Now it should be at the detail page
      expect(find.byType(TodoDetailView), findsOne);
      expect(find.text('Task title: Buy Groceries'), findsOne);
      expect(find.text('Favorite: no'), findsOne);

      // Go back to the main TodoView
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(TodoView), findsOne);
    });

    testWidgets(
      '8. Edit a task with valid input should show the updated task title',
      (WidgetTester tester) async {
        // mock the original data
        final editTask = TodoModel(
          id: 5,
          title: 'Buy Groceries',
          deadline: DateTime(2026, 12, 31),
        );

        // Define what getTask should do when called: return the single task
        when(() => mockTodoController.getTasks())
            .thenAnswer((_) async => [editTask]);

        // load page, in the code, it will getTask
        await tester.pumpWidget(TodoView(todoController: mockTodoController));
        await tester.pumpAndSettle();

        // Click edit icon to forward to the edit page
        await tester.tap(find.byIcon(Icons.edit).first);
        await tester.pumpAndSettle();

        // expect to see the edit page
        expect(find.byType(TodoEditView), findsOne);

        // Define mocked editTask()
        when(() => mockTodoController.editTask(any(), any()))
            .thenAnswer((_) async => editTask.title = 'Cook dinner');
        // Mock the edit method
        // editTask.title = 'Cook dinner';
        // Define new mocked fetchTasks() => return List with newly added task
        // when(() => mockTodoController.getTasks())
        //     .thenAnswer((_) async => [editTask]);

        // Act: Enter the task title into the TextField and tap 'Add'
        await tester.enterText(find.byType(TextField), 'Cook dinner');
        await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
        await tester.pumpAndSettle();

        // Now it should return to the first page with the updated task title
        expect(find.byType(TodoView), findsOne);
        expect(find.text('Cook dinner'), findsOne);
      },
      tags: "yes",
    );

    testWidgets('9. Search filters tasks and Reset restores the full list', (
      WidgetTester tester,
    ) async {
      final mockTodos = [
        TodoModel(id: 1, title: 'Cook lunch', deadline: DateTime(2026, 12, 31)),
        TodoModel(id: 2, title: 'Clean room', deadline: DateTime(2026, 12, 31)),
      ];
      when(() => mockTodoController.getTasks())
          .thenAnswer((_) async => mockTodos);

      await tester.pumpWidget(TodoView(todoController: mockTodoController));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'LUNCH');
      await tester.tap(find.widgetWithText(FilledButton, 'Search'));
      await tester.pumpAndSettle();

      expect(find.text('Cook lunch'), findsOne);
      expect(find.text('Clean room'), findsNothing);

      await tester.tap(find.widgetWithText(FilledButton, 'Reset'));
      await tester.pumpAndSettle();

      expect(find.text('Cook lunch'), findsOne);
      expect(find.text('Clean room'), findsOne);
    });
  });
}
