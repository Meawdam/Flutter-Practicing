class TodoModel {
  String id;
  String title;
  DateTime deadline;
  bool complete;
  bool favorite;

  TodoModel({
    required this.id,
    required this.title,
    required this.deadline,
    this.complete = false,
    this.favorite = false,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    DateTime deadline = DateTime.parse(json['deadline']);
    return TodoModel(
      id: json['id'],
      title: json['title'],
      deadline: deadline,
      complete: json['complete'] ?? false,
      favorite: json['favorite'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'deadline': deadline.toString(),
      'complete': complete,
      'favorite': favorite
    };
  }
}
