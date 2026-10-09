import 'package:flutter/material.dart';
import 'package:frontend/controller/counter_controller.dart';

class CounterView extends StatefulWidget {
  const new({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final countController = CounterController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Counter app')),
        body: Align(
          alignment: .topCenter,
          child: Text('Count = ${countController.count}', style: TextStyle(fontSize: 33)),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: .end,
          children: [
            FloatingActionButton(onPressed: (){
              setState(() {
                countController.add();
              });
            }, child: Icon(Icons.add),),
            SizedBox(height: 4,),
            FloatingActionButton(onPressed: (){
              setState(() {
                countController.reset();
              });
            }, child: Icon(Icons.lock_reset),)
          ],
        ),
      ),
    );
  }
}
