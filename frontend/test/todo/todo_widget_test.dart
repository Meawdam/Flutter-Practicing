import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/todo/views/todo_view.dart';

void main() {
  testWidgets('1. Launch app should show blank todos', (tester) async {
    // Build the widget.
    await tester.pumpWidget(TodoView());

    // Expect to find the 0 todo ListTiles.
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('2. Add empty task should be unsuccessful', (tester) async {
    // Build the widget.
    await tester.pumpWidget(TodoView());

    // Click the add button without input
    await tester.tap(find.text('Add'));
    // Wait until the action done
    await tester.pump();
    // Expect to find no task.
    expect(find.byType(ListTile), findsNothing);

    // Add empty todo text
    await tester.enterText(find.byType(TextField), '');
    // Click the add button
    await tester.tap(find.text('Add'));
    // Wait until the action done
    await tester.pump();
    // Expect to find no task.
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('3. Add task should show the new task', (tester) async {
    // Build the widget.
    await tester.pumpWidget(TodoView());
    // Add new todo text
    await tester.enterText(find.byType(TextField), 'Clean room');
    // Click the add button
    await tester.tap(find.text('Add'));
    // Wait until the action done
    await tester.pump();

    // Expect to find the new task.
    expect(find.byType(ListTile), findsOne);
    // Expect to find the new task with the title.
    expect(find.text('Clean room'), findsOne);
  });

  testWidgets('4. Delete task should remove task', (tester) async {
    // Build the widget.
    await tester.pumpWidget(TodoView());

    // add new task
    await tester.enterText(find.byType(TextField), 'Cook dinner');
    // Click the add button
    await tester.tap(find.text('Add'));
    // Wait until the action done
    await tester.pump();
    // should have one task
    final taskFinder = find.text('Cook dinner');
    expect(taskFinder, findsOne);

    // Swipe right to delete a specific task
    await tester.drag(taskFinder, Offset(500.0, 0.0));
    // Wait until the action done
    await tester.pumpAndSettle();

    // Expect to find no task.
    expect(taskFinder, findsNothing);
  });

  testWidgets('5. Tap the task should toggle the task status', (tester) async {
    // Build the widget and add new task
    await tester.pumpWidget(TodoView());
    await tester.enterText(find.byType(TextField), 'Clean room');
    await tester.tap(find.text('Add'));
    await tester.pump();

    //find the task's text and decoration
    //the default task status is false (no decoration)
    Finder taskFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          widget.data == 'Clean room' &&
          widget.style?.decoration == TextDecoration.none,
    );
    expect(taskFinder, findsOne);

    // toggle the task, now the complete status is true (linethrough)
    await tester.tap(find.text('Clean room'));
    await tester.pump();
    taskFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          widget.data == 'Clean room' &&
          widget.style?.decoration == TextDecoration.lineThrough,
    );
    expect(taskFinder, findsOne);
  });

  testWidgets('6. Tap the favorite icon should toggle the favorite color', (
    tester,
  ) async {
    // Build the widget and add new task
    await tester.pumpWidget(TodoView());
    await tester.enterText(find.byType(TextField), 'Clean room');
    await tester.tap(find.text('Add'));
    await tester.pump();

    // 1. Locate the IconButton containing the Icons.star
    final Finder iconButtonFinder = find.byWidgetPredicate((Widget widget) {
      return widget is IconButton &&
          widget.icon is Icon &&
          (widget.icon as Icon).icon == Icons.star;
    });
    expect(iconButtonFinder, findsOne);

    // 2. Extract the IconButton widget instance
    IconButton iconButtonWidget = tester.widget<IconButton>(iconButtonFinder);

    // 3. Assert its initial color property is grey
    expect(iconButtonWidget.color, Colors.grey);

    // 4. Tap the IconButton
    await tester.tap(iconButtonFinder);
    await tester.pump();

    // 5. Extract the updated widget instance and assert it changed to amber
    iconButtonWidget = tester.widget<IconButton>(iconButtonFinder);
    expect(iconButtonWidget.color, Colors.amber);
  });

  testWidgets('7. Click view icon should navigate to the detail page', (
    tester,
  ) async {
    // Build the widget.
    await tester.pumpWidget(TodoView());

    // add new task
    await tester.enterText(find.byType(TextField), 'Cook dinner');
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Click the view icon
    await tester.tap(find.byIcon(Icons.zoom_in));
    // Wait until the navigation done
    await tester.pumpAndSettle();

    // Expect to find texts in the next page
    expect(find.textContaining('Cook dinner'), findsOne);
    expect(find.text('Complete: false'), findsOne);
    expect(find.text('Favorite: false'), findsOne);
  });

  testWidgets(
    '8. Click edit icon should navigate to the edit page and update the task title',
    (tester) async {
      // Build the widget.
      await tester.pumpWidget(TodoView());

      // add new task
      await tester.enterText(find.byType(TextField), 'Cook dinner');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Click the view icon
      await tester.tap(find.byIcon(Icons.edit));
      // Wait until the navigation done
      await tester.pumpAndSettle();

      // Expect to find texts in the next page
      expect(find.textContaining('Cook dinner'), findsOne);

      // update task title
      await tester.enterText(find.byType(TextField), 'Do homework');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Expect to find texts in the main page
      expect(find.text('Do homework'), findsOne);
    },
  );

  testWidgets('9. Cancel the edit should not change the task title', (
    tester,
  ) async {
    // Build the widget.
    await tester.pumpWidget(TodoView());

    // add new task
    await tester.enterText(find.byType(TextField), 'Cook dinner');
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Click the view icon
    await tester.tap(find.byIcon(Icons.edit));
    // Wait until the navigation done
    await tester.pumpAndSettle();

    // Expect to find texts in the next page
    expect(find.textContaining('Cook dinner'), findsOne);

    // cancel the edit
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Expect to find texts in the main page
    expect(find.text('Cook dinner'), findsOne);
  });

  testWidgets('10. Show All, Pending, Complete, Favorite Correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TodoView());

    expect(
      find.text('All: 0, Pending: 0 ,Complete: 0 , Favorite: 0'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), 'Do homework');
    await tester.tap(find.text('Add'));
    await tester.pump();
    expect(
      find.text('All: 1, Pending: 1 ,Complete: 0 , Favorite: 0'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.star));
    await tester.pump();
    expect(
      find.text('All: 1, Pending: 1 ,Complete: 0 , Favorite: 1'),
      findsOneWidget,
    );

    await tester.tap(find.text('Do homework'));
    await tester.pump();
    expect(
      find.text('All: 1, Pending: 0 ,Complete: 1 , Favorite: 1'),
      findsOneWidget,
    );
  });
}
