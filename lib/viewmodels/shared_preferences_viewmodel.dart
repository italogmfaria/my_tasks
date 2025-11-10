import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../repositories/shared_preferences_repository.dart';

class SharedPreferencesViewModel extends ChangeNotifier {
  final SharedPreferencesRepository _repository = SharedPreferencesRepository();
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _repository.loadTasks();
    } catch (e) {
      print('Erro ao inicializar SharedPreferences ViewModel: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );

    try {
      await _repository.addTask(task);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      print('Erro ao adicionar tarefa: $e');
      rethrow;
    }
  }

  Future<void> toggleTask(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    final updatedTask = _tasks[index].copyWith(done: !_tasks[index].done);

    try {
      await _repository.updateTask(updatedTask);
      _tasks[index] = updatedTask;
      notifyListeners();
    } catch (e) {
      print('Erro ao alternar tarefa: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      print('Erro ao excluir tarefa: $e');
      rethrow;
    }
  }

  Future<void> clearAll() async {
    try {
      await _repository.clearAll();
      _tasks.clear();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}

