class TodoModel {
  String id;
  String title;
  bool complete = false;
  bool favorite = false;
  DateTime deadline = DateTime.now();

  //constructor
  TodoModel({this.id = '', required this.title, required this.deadline});

  // method to convert JSON to model (fromJSON)
  factory TodoModel.fromJSON(Map<String, dynamic> json) {
    final deadline = DateTime.parse(json['deadline']);
    return TodoModel(id: json['id'], title: json['title'], deadline: deadline);
  }

  // method to convert model to JSON (toJSON)
}
