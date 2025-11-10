import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileRepository {
  static const String _fileName = 'tasks.json';
  static const String _webStorageKey = 'tasks_file_web';

  bool get _isWebPlatform => kIsWeb;

  Future<String> _localPath() async {
    if (_isWebPlatform) {
      throw UnsupportedError('Caminho de arquivo não disponível na web');
    }
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile() async {
    final path = await _localPath();
    return File('$path/$_fileName');
  }

  Future<List<Task>> loadTasks() async {
    try {
      if (_isWebPlatform) {
        final prefs = await SharedPreferences.getInstance();
        final tasksJson = prefs.getString(_webStorageKey);

        if (tasksJson == null || tasksJson.isEmpty) {
          return [];
        }

        final List<dynamic> tasksList = json.decode(tasksJson);
        return tasksList.map((taskJson) => Task.fromJson(taskJson)).toList();
      } else {
        final file = await _localFile();

        if (!await file.exists()) {
          return [];
        }

        final contents = await file.readAsString();
        if (contents.isEmpty) {
          return [];
        }

        final List<dynamic> tasksList = json.decode(contents);
        return tasksList.map((taskJson) => Task.fromJson(taskJson)).toList();
      }
    } catch (e) {
      print('Erro ao carregar tarefas do arquivo: $e');
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());

      if (_isWebPlatform) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_webStorageKey, tasksJson);
      } else {
        final file = await _localFile();
        await file.writeAsString(tasksJson);
      }
    } catch (e) {
      print('Erro ao salvar tarefas no arquivo: $e');
      rethrow;
    }
  }

  Future<void> addTask(Task task) async {
    final tasks = await loadTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(Task task) async {
    final tasks = await loadTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String id) async {
    final tasks = await loadTasks();
    tasks.removeWhere((task) => task.id == id);
    await saveTasks(tasks);
  }

  Future<void> clearAll() async {
    try {
      if (_isWebPlatform) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_webStorageKey);
      } else {
        final file = await _localFile();
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Erro ao limpar tarefas: $e');
      rethrow;
    }
  }
}

