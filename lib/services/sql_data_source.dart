import '../models/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'idata_source.dart';
import 'package:path/path.dart';

class SQLDataSource implements IDataSource {
  late Database database;
  late Future init;

  SQLDataSource() {
    init = initialise();
  }

  Future<void> initialise() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'todo_data.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE IF NOT EXISTS todos(id INTEGER PRIMARY KEY, name TEXT, description TEXT, completed INTEGER)');
      },
      version: 1,
    );}

  @override
  Future<bool> add(Todo model) async {
    Map<String, dynamic> map = model.toMap();
    map.remove('id');
    return await database.insert('todos', map) == 0 ? false : true;
  }

  @override
  Future<List<Todo>> browse() async {
    await init;
    List<Map<String, dynamic>> maps = await database.query('todos');
    return List.generate(maps.length, (index) {
      return Todo.fromMap(maps[index]);
    });
  }

  @override
  Future<bool> delete(Todo model) async {
    Map<String, dynamic> map = model.toMap();
    await map.remove(model);
    await database.delete('todos', where: 'id = ${model.id}');
    return true;
  }

  @override
  Future<bool> edit(Todo model) async { // TODO: Value does not change
    Map<String, dynamic> map = model.toMap();
    map.update('completed', (value) => model.completed);
    await database.update('todos', map, where: 'id = ${model.id}');
    return true;
  }

  @override
  Future<Todo> read(String id) async {
    List<Map<String, dynamic>> map =
        await database.query('todos', where: 'id = $id');

    if (map.isNotEmpty) {
      return Todo.fromMap(map.first);
    } else {
      throw Exception("Todo with ID $id not found.");
    }
  }
}
