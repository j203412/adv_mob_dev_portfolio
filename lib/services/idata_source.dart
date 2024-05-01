import '../models/todo.dart';

abstract class IDataSource {
  Future<List<Todo>> browse();
  Future<Todo> read(String id);
  Future<bool> edit(Todo model);
  Future<bool> add(Todo model);
  Future<bool> delete(Todo model);
}
