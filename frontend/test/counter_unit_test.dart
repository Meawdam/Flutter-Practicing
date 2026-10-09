import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/controller/counter_controller.dart';

void main() {
  test('1. At first, the counter should be 0', () {
    final counterController = CounterController();
    expect(counterController.count, 0);
  });

  test('2. Add method should increase the counter', () {
    final counterController = CounterController();
    //before
    expect(counterController.count, 0);
    //after
    counterController.add();
    expect(counterController.count, 1);
  });

    test('3. Reset method should reset the counter', () {
    final counterController = CounterController();
    counterController.add();
    expect(counterController.count, 1);
    //reset
    counterController.reset();
    expect(counterController.count, 0);
  });
}