import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../firebase_options.dart';
import '../models/todo.dart';
import 'idata_source.dart';

class RemoteAPIDataSource implements IDataSource {
  late FirebaseDatabase
      database; // "Error: LateInitializationError: Field 'database' has not been initialized."
  late Future initTask;

  // ignore: non_constant_identifier_names
  RemoteAPIDataSource() {
    initTask = Future(() async {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      database = FirebaseDatabase.instance;
    });
  }

  // @override
  // Future<bool> add(Todo model) async {
  //   await initTask;
  //   try {
  //     DatabaseReference data = database
  //         .ref()
  //         .child('todos')
  //         .push(); // Get database reference (data location)
  //     Map<String, dynamic> newMap =
  //         model.toMap(); // Instantiate passed model as map
  //     newMap.remove('id'); // Remove id from map
  //     data.set(newMap); // Set new map to database
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  @override
  Future<bool> add(Todo model) async {
    await initTask;
    try {
      await database.ref('todos').push().set(model.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Todo>> browse() async {
    await initTask;
    List<Todo> todos = <Todo>[];
    final DataSnapshot snapshot = await database.ref().child('todos').get();

    if (!snapshot.exists) {
      throw Exception(
          "Invalid Request - Cannot find snapshot: ${snapshot.ref.path}");
    }

    Map<String, dynamic> data = Map.from(snapshot.value
        as Map); // Instantiate snapshot values by first casting as Map type

    data.forEach((key, value) {
      // Iterate over each key value pair
      Map<String, dynamic> todoData =
          Map.from(value); // Instantiate pair value as Map type
      todoData['id'] = key;
      // Set key to id
      todos.add(Todo.fromJson(todoData));
      // Add key value pairs to list as Todo type
    });

    return todos;
  }

  @override
  Future<bool> delete(Todo model) async {
    await initTask;
    try {
      await database.ref().child('todos').child(model.id).remove();
      return true;
    } catch (e) {
      log("Error deleting todo: $e");
      return false;
    }
  }

  @override
  Future<bool> edit(Todo model) async {
    await initTask;
    try {
      await database.ref().child('todos').child(model.id).set(
          model.toMap()); // TODO: 'completed' value does not return updated
      return true;
    } catch (e) {
      log("Error editing todo: $e");
      return false;
    }
  }

  @override
  Future<Todo> read(String id) async {
    await initTask;
    final DataSnapshot snapshot = await database.ref().child('todos/$id').get();

    if (!snapshot.exists) {
      throw Exception("Todo with ID $id not found.");
    }

    final Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;

    return Todo.fromJson(data);
  }
}
