import 'package:flutter/material.dart';

import 'dart:math';

class LabTest extends StatefulWidget {
  const new({super.key});

  @override
  State<LabTest> createState() => _LabTestState();
}

class _LabTestState extends State<LabTest> {
  Random rand = Random();
  TextEditingController ctr_1 = TextEditingController();
  TextEditingController ctr_2 = TextEditingController();
  TextEditingController ctr_3 = TextEditingController();
  TextEditingController ctr_4 = TextEditingController();

  int share_1 = 0;
  int share_2 = 0;
  int share_3 = 0;
  String result = '';

  void random() {
    int? expense = int.tryParse(ctr_1.text.trim());
    if (expense == null) {
      setState(() {
        result = 'Error: no expense';
      });
      return;
    }
    int sum = 100;
    share_1 = rand.nextInt(49) + 1;
    sum -= share_1;
    share_2 = rand.nextInt(49) + 1;
    share_3 = sum - share_2;

    double split_1 = (expense / 100) * share_1;
    double split_2 = (expense / 100) * share_2;
    double split_3 = (expense / 100) * share_3;

    setState(() {
      ctr_2.text = share_1.toString();
      ctr_3.text = share_2.toString();
      ctr_4.text = share_3.toString();

      result =
          'Split -> F1: ${split_1.toStringAsFixed(2)} F2: ${split_2.toStringAsFixed(2)} F3: ${split_3.toStringAsFixed(2)}';
    });
  }

  void calculate() {
    int? expense = int.tryParse(ctr_1.text.trim());
    if (expense == null) {
      setState(() {
        result = 'Error: no expense';
      });
      return;
    }
    int? expense_1 = int.tryParse(ctr_2.text.trim());
    int? expense_2 = int.tryParse(ctr_3.text.trim());
    int? expense_3 = int.tryParse(ctr_4.text.trim());

    if (expense_1 == null || expense_2 == null || expense_3 == null) {
      setState(() {
        result = 'Error: Invalid input';
      });
      return;
    }

    share_1 = expense_1;
    share_2 = expense_2;
    share_3 = expense_3;

    double split_1 = (expense / 100) * share_1;
    double split_2 = (expense / 100) * share_2;
    double split_3 = (expense / 100) * share_3;

    setState(() {
      ctr_2.text = share_1.toString();
      ctr_3.text = share_2.toString();
      ctr_4.text = share_3.toString();

      result =
          'Split -> F1: ${split_1.toStringAsFixed(2)} F2: ${split_2.toStringAsFixed(2)} F3: ${split_3.toStringAsFixed(2)}';
    });
  }

  void reset() {
    ctr_1.clear();
    ctr_2.clear();
    ctr_3.clear();
    ctr_4.clear();


    setState(() {
      result = '';
      share_1 = 0;
      share_2 = 0;
      share_3 = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  textAlign: .center,
                  textAlignVertical: .center,
                  controller: ctr_1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Total expense',
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.pink,
                      child: Column(
                        children: [
                          Text('friend 1'),
                          Image.asset('assets/images/friend1.png', height: 64),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: .center,
                              textAlignVertical: .center,
                              controller: ctr_2,
                              decoration: InputDecoration(hintText: '%'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      color: Colors.green,
                      child: Column(
                        children: [
                          Text('friend 2'),
                          Image.asset('assets/images/friend2.png', height: 64),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: .center,
                              textAlignVertical: .center,
                              controller: ctr_3,
                              decoration: InputDecoration(hintText: '%'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      color: Colors.blue,
                      child: Column(
                        children: [
                          Text('friend 3'),
                          Image.asset('assets/images/friend3.png', height: 64),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: .center,
                              textAlignVertical: .center,
                              controller: ctr_4,
                              decoration: InputDecoration(hintText: '%'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: .center,
                children: [
                  ElevatedButton(onPressed: random, child: Text('Random')),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: calculate,
                    child: Text('Calculate'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(onPressed: reset, child: Text('Reset')),
                ],
              ),
              SizedBox(height: 16),
              Text(result),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: .center,
                children: [
                  for (int i = 0; i < (share_1 / 10).round(); i++)
                    Icon(Icons.person, color: Colors.pink),
                  for (int i = 0; i < (share_2 / 10).round(); i++)
                    Icon(Icons.person, color: Colors.green),
                  for (int i = 0; i < (share_3 / 10).round(); i++)
                    Icon(Icons.person, color: Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
