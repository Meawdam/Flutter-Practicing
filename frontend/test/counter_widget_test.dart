import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/views/counter_view.dart';

void main() {
  testWidgets('1. At first the counter should be 0.', (WidgetTester tester) async {
    //launch the app
    await tester.pumpWidget(CounterView());
    //search for the counter text
    Finder textFinder = find.text('Count = 0');
    //expect to find the text
    expect(textFinder, findsOne);
  });
}