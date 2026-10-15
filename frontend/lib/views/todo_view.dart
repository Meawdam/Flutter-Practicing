import 'package:flutter/material.dart';
import 'package:frontend/controller/todo_controller.dart';
import 'package:frontend/model/todo_model.dart';
import 'package:frontend/views/todo_edit_view.dart';

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
  List<TodoModel> todos = [];

  void fetchTask() async {
    todos = await todoController.fetchTask();
    setState(() {});
  }

  void addTask() async {
    String title = textController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: no title')));
      return;
    }
    await todoController.addTask(title, DateTime.now());
    textController.clear();
    fetchTask();
  }

  void gotoEdit(int index) async {
    String id = todos[index].id;
    String title = todos[index].title;
    String? newTitle = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoEditView(title: title)),
    );
    if (newTitle == null) {
      return;
    }
    await todoController.editTask(id, title);
    fetchTask();
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
                  controller: textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'New task',
                  ),
                ),
              ),
              SizedBox(width: 4),
              OutlinedButton.icon(onPressed: null, label: Text('Deadline')),
              SizedBox(width: 4),
              FilledButton(onPressed: addTask, child: Text('Add')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.star),
                    title: Text(todos[index].title),
                    trailing: Wrap(
                      children: [
                        IconButton(onPressed: null, icon: Icon(Icons.search)),
                        IconButton(
                          onPressed: () => gotoEdit(index),
                          icon: Icon(Icons.edit),
                        ),
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
