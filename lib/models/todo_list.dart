import 'dart:collection';
import 'package:get/instance_manager.dart';
import '../services/idata_source.dart';
import 'package:flutter/material.dart';
import 'todo.dart';

// Managages the state of the todos.
class TodoList extends ChangeNotifier {

  List<Todo> _todos = [];
  final IDataSource _datasource = Get.find<IDataSource>();
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length; // Getter

  void add(Todo todo) async {
    await _datasource.add(todo);
    notifyListeners(); // Triggers the update of each consumer
  }

  void remove(Todo todo) async {
    await _datasource.delete(todo);
    notifyListeners();
  }

  void removeAll() async {
    _todos.clear();
    notifyListeners();
  }

  void updateTodo(Todo todo) async {
    await _datasource.edit(todo);
    notifyListeners();
  }

  Future<List<Todo>> refresh() async {
    _todos = await _datasource.browse();
    // notifyListeners();
    return _todos;
  }
}
