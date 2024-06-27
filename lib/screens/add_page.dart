import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/todo_provider.dart';

import 'package:todo_app/services/todo_services.dart';

import '../utlis/snackbar_helper.dart';

class AddTodopage extends StatefulWidget {
  final Map? todo;

  const AddTodopage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodopage> createState() => _AddTodopageState();
}

class _AddTodopageState extends State<AddTodopage> {
  TextEditingController TitleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  bool isedit = false;

  @override
  void initState() {
    final todo = widget.todo;
    super.initState();
    if (todo != null) {
      isedit = true;
      final title = todo['title'];
      final description = todo['description'];
      TitleController.text = title;
      DescriptionController.text = description;
    }
  }

  List items = [];

  @override
  Widget build(BuildContext context) {
    print('object');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isedit ? 'Edit todo' : 'Add Todo',
        ),
      ),
// we can use column also in place of listview but it preevents overflow error if keyboard is displayed
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              controller: TitleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: DescriptionController,
              decoration: InputDecoration(hintText: 'Description'),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
  onPressed: () async {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    if (isedit) {
      await updateData(context, todoProvider);
    } else {
      await submitData(context, todoProvider);
    }
  },
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(isedit ? 'Update' : 'Submit'),
  ),
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Color.fromRGBO(155, 0, 210, 1.0)),
  ),
)

              
            
          ],
        ),
      ),
    );
  }

  Future<void> updateData(
      BuildContext context, TodoProvider todoProvider) async {
// get data from user

    final todo = widget.todo;
    if (todo == null) {
      showErrorMessage(context,
          message: 'You can not call updated without todo data');
      return;
    }

    final id = todo['_id'];
    // final iscompleted = todo['is_completed'];

    final issuccess = await TodoServices.updateTodo(id, body);

    if (issuccess) {
      todoProvider.updateItem(body);
      showSuccessMessage(context, message: 'updation Success');
    } else {
      showErrorMessage(context, message: 'updation failed');
    }
  }

  Future<void> submitData(
      BuildContext context, TodoProvider todoProvider) async {
// submit it to server

    final issuccess = await TodoServices.addTodo(body);

//  show success or fail message based on status
    if (issuccess) {
      todoProvider.addItem(body);
      TitleController.text = '';
      DescriptionController.text = '';
      showSuccessMessage(context, message: 'creation Success');
    } else {
      showErrorMessage(context, message: 'creation failed');
    }
  }

// get data from user
  Map<String, dynamic> get body {
    final title = TitleController.text;
    final description = DescriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
