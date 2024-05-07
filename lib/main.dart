import 'package:get/get.dart';

import 'services/idata_source.dart';
import 'services/sql_data_source.dart'; // Does not yet retrieve data
import 'services/hive_data_source.dart'; // Does not yet retrieve data
import 'services/remote_api_data_source.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/todo_list.dart';
import 'widgets/todo_widget.dart';
import 'models/todo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<IDataSource>(RemoteAPIDataSource());
  runApp(ChangeNotifierProvider(
    create: (context) => TodoList(),
    child: const TodoApp(),
  ));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Consumer<TodoList>(builder: (context, model, child) {
          return FutureBuilder(
            // Refreshes self when something changes
            future: model
                .refresh(), // Calls the refresh() -> browse() method in chosen data source
            builder: (context, snapshot) {
              // Snapshot refers to the return data of the called method
              if (snapshot.hasError) {
                return const Icon(Icons.error);
              }
              if (snapshot.hasData) {
                return RefreshIndicator(
                    onRefresh: model.refresh,
                    child: ListView.builder(
                        itemCount: model.todoCount,
                        itemBuilder: (context, index) {
                          return TodoWidget(todo: model.todos[index]);
                        }));
              } else {
                return const CircularProgressIndicator(); // Loading state
              }
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTodo,
        child: const Icon(
          Icons.add_circle,
        ),
      ),
    );
  }

  void _openAddTodo() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _controlName = TextEditingController();
        final TextEditingController _controlDescription =
            TextEditingController();
        // TODO: Add validation
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name: '),
                  controller: _controlName,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description: '),
                  controller: _controlDescription,
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        setState(() {
                          Provider.of<TodoList>(context, listen: false).add(
                              Todo(
                                  id: '',
                                  name: _controlName.text,
                                  description: _controlDescription.text));
                        });
                        Navigator.pop(context);
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
