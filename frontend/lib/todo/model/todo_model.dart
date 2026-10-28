class TodoModel {
  int id;
  String title;
  DateTime deadline;
  int complete;
  int favorite;

  TodoModel({
    required this.id,
    required this.title,
    required this.deadline,
    this.complete = 0,
    this.favorite = 0,
  });

  factory TodoModel.fromJSON(Map<String, dynamic> json) {
    DateTime deadline = DateTime.parse(json['deadline']);
    return TodoModel(
      id: json['id'],
      title: json['title'],
      deadline: deadline,
      complete: json['complete'],
      favorite: json['favorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'deadline': deadline.toString(),
      'complete': complete,
      'favorite': favorite,
    };
  }
}
