import 'package:flutter/material.dart';
import 'package:frontend/controller/todo_controller.dart';
import 'package:frontend/model/todo_model.dart';

class TodoView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Todo App')),
        body: TodoApp(),
      ),
    );
  }
}

class TodoApp extends StatefulWidget {
  const new({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final todoController = TodoController();
  List<TodoModel> todos = [];

  void fetchTask() async {
    todos = await todoController.fetchTask();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'New task',
                  ),
                ),
              ),
              SizedBox(width: 4),
              OutlinedButton.icon(onPressed: null, label: Text('Deadline')),
              SizedBox(width: 4),
              FilledButton(onPressed: null, child: Text('Add')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.star),
                    title: Text(todos[index].title),
                    trailing: Wrap(
                      children: [
                        IconButton(onPressed: null, icon: Icon(Icons.search)),
                        IconButton(onPressed: null, icon: Icon(Icons.edit)),
                        IconButton(
                          onPressed: null,
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
