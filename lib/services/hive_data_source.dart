import '../models/todo.dart';
import 'idata_source.dart';
import 'package:hive_flutter/adapters.dart';

class HiveDataSource implements IDataSource {
  late final Future init;

  Future<void> initialise() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());

    // ignore: unused_element, non_constant_identifier_names
    HiveDataSource() {
      init = initialise();
    }
  }

  @override
  Future<bool> add(Todo model) async {
    await init;
    Box<Todo> box = Hive.box('todos');
    await box.add(model);
    return true;
  }

  @override
  Future<List<Todo>> browse() async {
    Box<Todo> box = Hive.box('todos');
    return box.values.toList().cast();
  }

  @override
  Future<bool> delete(Todo model) async {
    final box = await Hive.openBox('todos');
    try {
      if (model.id != null) {
        await box.delete(model);
        return true;
      } else {
        return false;
      }
    } finally {
      await box.close();
    }
  }

  @override
  Future<bool> edit(Todo model) async {
    @override
    final box = await Hive.openBox('todos');
    try {
      if (box.containsKey(model.id)) {
        await box.put(model.id, model);
        return true;
      } else {
        return false;
      }
    } finally {
      await box.close();
    }
  }

  @override
  Future<Todo> read(String id) async {
    return await Hive.openBox('todos').then((box) => box.get(id));
  }
}
