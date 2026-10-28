import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/todo/model/todo_model.dart';
import 'package:http/http.dart' as http;

class TodoController {
  static const String baseURL = 'http://localhost:3000/api';

  static List<TodoModel> filterTasks(List<TodoModel> tasks, String query) {
    final searchQuery = query.trim().toLowerCase();
    return tasks
        .where((task) => task.title.toLowerCase().contains(searchQuery))
        .toList();
  }

  Future<List<TodoModel>> getTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/todo'));
      if (response.statusCode != 200) {
        throw Exception('Server error');
      }
      List data = jsonDecode(response.body);
      return data.map((json) => TodoModel.fromJSON(json)).toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Connection error');
    }
  }

  // add new task
  Future<void> addTask(String title, DateTime deadline) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/todo'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'title': title,
          'deadline': deadline.toIso8601String(),
          'complete': 0,
          'favorite': 0,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to add new task: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to the server.');
    }
  }

  // delete task
  Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseURL/todo/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete the task: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to the server.');
    }
  }

  // edit task
  Future<void> editTask(int id, String title) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseURL/todo/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'title': title}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to the server.');
    }
  }

  // toggle complete/favorite
  Future<void> toggleTask(int id, String type, int status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseURL/toggle/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'type': type, 'status': status}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to the server.');
    }
  }
}
