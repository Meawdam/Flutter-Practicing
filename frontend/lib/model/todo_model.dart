class TodoModel {
  String title = '';
  DateTime deadline = DateTime.now();
  bool favorite = false;
  bool complete = false;

  //constructor
  TodoModel({required this.title, required this.deadline});
}