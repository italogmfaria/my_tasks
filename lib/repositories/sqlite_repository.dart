import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SQLiteRepository {
  static const String _databaseName = 'tasks.db';
  static const int _databaseVersion = 1;
  static const String _tableName = 'tasks';

  Database? _database;
  List<Task> _webFallbackTasks = [];

  bool get _isSupported => !kIsWeb;

  Future<Database?> get database async {
    if (!_isSupported) return null;
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<List<Task>> loadTasks() async {
    if (!_isSupported) {
      print('SQLite não suportado na plataforma web - usando armazenamento em memória');
      return _webFallbackTasks;
    }

    try {
      final db = await database;
      if (db == null) return [];

      final List<Map<String, dynamic>> maps = await db.query(_tableName);

      return maps.map((map) {
        return Task(
          id: map['id'] as String,
          title: map['title'] as String,
          done: (map['done'] as int) == 1,
        );
      }).toList();
    } catch (e) {
      print('Erro ao carregar tarefas do SQLite: $e');
      return [];
    }
  }

  Future<void> addTask(Task task) async {
    if (!_isSupported) {
      _webFallbackTasks.add(task);
      return;
    }

    try {
      final db = await database;
      if (db == null) return;

      await db.insert(
        _tableName,
        {
          'id': task.id,
          'title': task.title,
          'done': task.done ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Erro ao adicionar tarefa no SQLite: $e');
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    if (!_isSupported) {
      final index = _webFallbackTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _webFallbackTasks[index] = task;
      }
      return;
    }

    try {
      final db = await database;
      if (db == null) return;

      await db.update(
        _tableName,
        {
          'title': task.title,
          'done': task.done ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      print('Erro ao atualizar tarefa no SQLite: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    if (!_isSupported) {
      _webFallbackTasks.removeWhere((task) => task.id == id);
      return;
    }

    try {
      final db = await database;
      if (db == null) return;

      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Erro ao excluir tarefa do SQLite: $e');
      rethrow;
    }
  }

  Future<void> clearAll() async {
    if (!_isSupported) {
      _webFallbackTasks.clear();
      return;
    }

    try {
      final db = await database;
      if (db != null) {
        await db.delete(_tableName);
      }
    } catch (e) {
      print('Erro ao limpar tarefas do SQLite: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    if (!_isSupported) return;

    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

