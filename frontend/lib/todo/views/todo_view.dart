import 'package:flutter/material.dart';
import 'package:frontend/todo/controller/todo_controller.dart';
import 'package:frontend/todo/model/todo_model.dart';
import 'package:frontend/todo/views/todo_detail_view.dart';
import 'package:frontend/todo/views/todo_edit_view.dart';

class TodoView extends StatelessWidget {
  // const new({super.key});
  // Two lines below are useful for widget test
  final TodoController? todoController;
  const TodoView({super.key, this.todoController});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Todo List')),
        body: TodoApp(todoController: todoController),
      ),
    );
  }
}

class TodoApp extends StatefulWidget {
  // const TodoApp({super.key});
  // for widget test, we pass the mockup data through the constructor
  final TodoController? todoController;
  const TodoApp({super.key, this.todoController});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late TodoController todoController;
  final textController = TextEditingController();
  final searchController = TextEditingController();
  String searchQuery = '';
  DateTime? dt;

  Future<void> setDeadline() async {
    dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, 12, 31),
    );
  }

  Future<void> addTodo() async {
    String newTodo = textController.text.trim();
    if (newTodo.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: No input')));
      return;
    }
    // if(dt == null) dt = DateTime.now();
    dt ??= DateTime.now();

    // add task and refresh page
    await todoController.addTask(newTodo, dt!);
    textController.clear();
    setState(() {});
  }

  Future<void> deleteTodo(int id) async {
    await todoController.deleteTask(id);
    setState(() {});
  }

  Future<void> toggleStatus(int id, String type, int status) async {
    await todoController.toggleTask(id, type, 1 - status);
    setState(() {});
  }

  void searchTasks() {
    setState(() {
      searchQuery = searchController.text.trim().toLowerCase();
    });
  }

  void resetSearch() {
    searchController.clear();
    setState(() {
      searchQuery = '';
    });
  }

  // to detail page
  void gotoDetailPage(TodoModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoDetailView(task: task)),
    );
  }

  // to edit page
  void gotoEditPage(TodoModel task) async {
    String? title = await Navigator.push(
      context,
      MaterialPageRoute<String>(builder: (context) => TodoEditView(task: task)),
    );
    if (!context.mounted) return;
    if (title == null) return;

    await todoController.editTask(task.id, title);
    setState(() {});
  }

  Widget buildSearchUI() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search task',
              ),
              onSubmitted: (_) => searchTasks(),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(onPressed: searchTasks, child: const Text('Search')),
          const SizedBox(width: 4),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            onPressed: resetSearch,
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  // build ADD UI
  Widget buildAddUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'New task',
              ),
            ),
          ),
          SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: setDeadline,
            icon: Icon(Icons.calendar_today),
            label: Text('Deadline'),
          ),
          SizedBox(width: 4),
          FilledButton(onPressed: addTodo, child: Text('Add')),
        ],
      ),
    );
  }

  // build TODO UI
  Widget buildTodoUI() {
    return FutureBuilder(
      future: todoController.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildListView(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // build ListView
  Widget buildListView(List<TodoModel> data) {
    final filteredTasks = TodoController.filterTasks(data, searchQuery);

    return Expanded(
      child: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.star),
                color: task.favorite == 1 ? Colors.amber : Colors.grey,
                onPressed: () =>
                    toggleStatus(task.id, 'favorite', task.favorite),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.complete == 1 ? .lineThrough : .none,
                ),
              ),
              trailing: Wrap(
                children: [
                  IconButton(
                    icon: Icon(Icons.zoom_in),
                    onPressed: () => gotoDetailPage(task),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => gotoEditPage(task),
                  ),
                  // Note that we don't use Dismissible to delete
                  // It is required a manual delete and does not work well with FutureBuilder
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteTodo(task.id),
                  ),
                ],
              ),
              onTap: () => toggleStatus(task.id, 'complete', task.complete),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    todoController = widget.todoController ?? TodoController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [buildSearchUI(), buildAddUI(), buildTodoUI()]);
  }
}
