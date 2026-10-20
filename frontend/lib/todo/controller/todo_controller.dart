import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/todo/model/todo_model.dart';

class TodoController {
  static const String baseUrl = 'http://localhost:3000/todo';

  Future<List<TodoModel>> fetchTasks() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode != 200) throw Exception('Cannot fetch tasks');
      final List<dynamic> data = json.decode(res.body);
      return data.map((json) => TodoModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to server');
    }
  }

  Future<void> addTasks(String title, DateTime deadline) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'deadline': deadline.toString(),
          'complete': false,
          'favorite': false,
        }),
      );
      if (res.statusCode != 201) throw Exception('failed to add new task');
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to server');
    }
  }

    Future<void> deleteTasks(String id) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/$id'),
      );
      if (res.statusCode != 200) throw Exception('failed to delete');
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to server');
    }
  }

  Future<void> updateTasks(String id, String title) async {
    try {
      final res = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          'title': title,
        }),
      );
      if (res.statusCode != 200) throw Exception('failed to update title');
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to server');
    }
  }
}
