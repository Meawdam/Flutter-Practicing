import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/views/todo_view.dart';

void main() {
  testWidgets('1. At first should be no task', (WidgetTester tester) async {
    await tester.pumpWidget(TodoView());

    Finder findListTile = find.byType(ListTile);
    expect(findListTile, findsNothing);
  });

  testWidgets('2. Adding empty task should not show the task', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(TodoView());

    Finder findAddButton = find.text('Add');
    await tester.tap(findAddButton);
    await tester.pump();

    Finder findListTile = find.byType(ListTile);
    expect(findListTile, findsNothing);
  });

  testWidgets('3. Adding task should show the task', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(TodoView());

    Finder findTextField = find.byType(TextField);
    await tester.enterText(findTextField, 'Cook dinner');
    Finder findAddButton = find.text('Add');
    await tester.tap(findAddButton);
    await tester.pump();

    Finder findListTile = find.byType(ListTile);
    expect(findListTile, findsOne);
    Finder findTitle = find.text('Cook dinner');
    expect(findTitle, findsOne);
  });
}
