import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/todo_model.dart';
import 'package:http/http.dart' as http;

class TodoController {
  String url = 'http://localhost:3000/todo';

  Future<List<TodoModel>> fetchTask() async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        throw Exception('Connection Error');
      }
      List<dynamic> data = jsonDecode(res.body);
      List<TodoModel> result = data
          .map((json) => TodoModel.fromJSON(json))
          .toList();
      return result;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Server Error');
    }
  }

  void addTask(String title, DateTime deadline) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'deadline': deadline.toString(),
          'complete': false,
          'favorite': false,
        }),
      );
      if (res.statusCode != 201) {
        throw Exception('Connection Error');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Server Error');
    }
  }
}
