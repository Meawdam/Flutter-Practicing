import 'package:flutter/material.dart';
import 'package:frontend/controller/todo_controller.dart';

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
  final textController = TextEditingController();
  DateTime? deadline;

  void setDateline() async {
    deadline = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      initialDate: DateTime.now(),
    );
  }

  void addTask() {
    String title = textController.text.trim();
    if (title.isEmpty) {
      return;
    }
    deadline ??= DateTime.now();
    // if(deadline == null) {
    //   deadline = DateTime.now();
    // }
    setState(() {
      todoController.addTask(title, deadline!);
    });
    textController.clear();
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
                  controller: textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'NewTask',
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: setDateline,
                label: Text('Deadline'),
                icon: Icon(Icons.calendar_today),
              ),
              SizedBox(width: 4),
              FilledButton(onPressed: addTask, child: Text('Add')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoController.todos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.star),
                    title: Text(todoController.todos[index].title),
                    trailing: Wrap(
                      children: [Icon(Icons.zoom_in), Icon(Icons.edit)],
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
