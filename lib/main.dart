import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/todo_provider.dart';
import 'package:todo_app/screens/todo_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => TodoProvider(),
    child:  MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home:  ToDoListPage(),
    ),
    );
  }
}
