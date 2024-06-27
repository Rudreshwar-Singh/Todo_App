import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/add_page.dart';

import 'package:todo_app/widgets/todocard.dart';

import '../provider/todo_provider.dart';

class ToDoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
     WidgetsBinding.instance.addPostFrameCallback((_) {
      todoProvider.fetchTodo(context);
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ToDo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.blue,
          ),
        ),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, _, child) {
          return Visibility(
            visible: todoProvider.isLoading,
            child: Center(
              child: CircularProgressIndicator(),
            ),
            replacement: RefreshIndicator(
              onRefresh: () => todoProvider.fetchTodo(context),
              child: Visibility(
                visible: todoProvider.items.isNotEmpty,
                replacement: Center(
                  child: Text(
                    'No Todo item',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                child: ListView.builder(
                  itemCount: todoProvider.items.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final item = todoProvider.items[index];

                    return Todocard(
                      navigateEdit: (item) => navigatetoeditpage(context, item),
                      deleteById: (id) => todoProvider.deleteById(context, id),
                      index: index,
                      item: item,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigatetoAddPage(context),
        label: const Text('Add ToDo'),
        
      ),
    );
  }

  Future<void> navigatetoeditpage(BuildContext context, Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodopage(todo: item),
    );
    await Navigator.push(context, route);
    context.read<TodoProvider>().fetchTodo(context);
  }

  Future<void> navigatetoAddPage(BuildContext context) async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodopage(),
    );
    await Navigator.push(context, route);
    context.read<TodoProvider>().fetchTodo(context);
  }
}
