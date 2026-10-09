import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/views/counter_view.dart';

void main() {
  testWidgets('1. At first the counter should be 0.', (WidgetTester tester) async {
    //launch the app
    await tester.pumpWidget(CounterView());
    //search for the counter text
    // Finder textFinder = find.text('Count = 0');
    Finder textFinder = find.textContaining('0');
    //expect to find the text
    expect(textFinder, findsOne);
  });

    testWidgets('2. Clicking add FAB should increase the counter.', (WidgetTester tester) async {
    //launch the app
    await tester.pumpWidget(CounterView());
    //search for the counter text
    // Finder textFinder = find.text('Count = 0');
    Finder textFinder = find.textContaining('0');
    //expect to find the text
    expect(textFinder, findsOne);

    //click the add FAB
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    //should not find the "Count = 0"
    expect(textFinder, findsNothing);
    //should found "Count = 1"
    // textFinder = find.text('Count = 1');
    // expect(textFinder, findsOne);
    expect(find.text("Count = 1"), findsOne);
  });

  testWidgets('2. Clicking reset FAB should reset the counter.', (WidgetTester tester) async {
    //launch the app
    await tester.pumpWidget(CounterView());
    //click the add FAB
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text("Count = 1"), findsOne);

    await tester.tap(find.byIcon(Icons.lock_reset));
    await tester.pump();
    expect(find.text("Count = 0"), findsOne);

  });
}