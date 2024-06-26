import 'package:advanced_mobile_dev_portfolio/models/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  const TodoWidget({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  showConfirmDelete(BuildContext context) {

  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    }
  );

  Widget confirmDeleteButton = TextButton(
    child: const Text("Delete", style: TextStyle(color: Colors.red)),
    
    onPressed: () {
      Provider.of<TodoList>(context, listen: false)
      .remove(widget.todo);
      Navigator.of(context).pop();
},
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Delete Todo?"),
    content: const Text("This action cannot be undone."),
    actions: [
      cancelButton,
      confirmDeleteButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 500, maxWidth: 700),
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.all(7.5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 225, 224, 224),
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            blurRadius: 0.5,
            color: Colors.black54,
            offset: Offset(
              5.0,
              5.0,
            ),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.todo.name,
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                widget.todo.description,
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                      value: widget.todo.completed,
                      onChanged: (bool? value) {
                        setState(() {
                          widget.todo.completed = value!;
                          Provider.of<TodoList>(context, listen: false)
                              .updateTodo(widget.todo);
                        });
                      }),
                  IconButton(
                      onPressed: () {
                        showConfirmDelete(context);
                      },
                      icon: const Icon(Icons.delete),
                      highlightColor: Colors.red,
                      ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
