import '../models/todo.dart';
import 'idata_source.dart';
import 'package:hive_flutter/adapters.dart';

class HiveDataSource implements IDataSource {
  late final Future init;
  late final Box<Todo> todosBox;

  HiveDataSource() {
    init = initialise();
  }

  Future<void> initialise() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    todosBox = await Hive.openBox('todos');
  }

  @override
  Future<bool> add(Todo model) async {
    await init;
    await todosBox.add(model);
    return true;
  }

  @override
  Future<List<Todo>> browse() async {
    await init;
    return todosBox.values.toList().cast();
  }

  @override
  Future<bool> delete(Todo model) async {
    await init;
    await todosBox.delete(model.key);
    return true;
  }

  @override
  Future<bool> edit(Todo model) async {
    await init;
    if (todosBox.containsKey(model.key)) {
      await todosBox.put(model.key, model);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Todo> read(String id) async {
    return await Hive.openBox('todos').then((box) => box.get(id));
  }
}
