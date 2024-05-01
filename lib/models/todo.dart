import '../util.dart' as util;
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final dynamic id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool completed;

  Todo(
      {this.id,
      required this.name,
      required this.description,
      this.completed = false});

  Map<String, dynamic> toMap() {
    // Map is a dictionary (key/value pair).
    return {
      'id': id,
      'name': name,
      'description': description,
      'completed': completed,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        completed: util.getBool(map['completed']));
  }

  // factory Todo.fromMap(Map<String, dynamic> map) {
  //   bool completed = map['completed'] is int
  //       ? map['completed'] == 0
  //           ? false
  //           : false
  //       : map['completed'];
  //   return Todo(map['id'], map['name'], map['description'], completed);
  // }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      completed: json['completed'],
    );
  }

  @override
  String toString() {
    return "$name - $description";
  }
}

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  Todo read(BinaryReader reader) {
    return Todo(
        id: reader.read(0),
        name: reader.read(1),
        description: reader.read(2),
        completed: reader.read(3));
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.completed);
  }
}
