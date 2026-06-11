import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoList App"),
        backgroundColor: Colors.lightBlue,
        foregroundColor: const Color.fromARGB(255, 18, 43, 87),
      ),

      body: const Center(child: Text("Nenhuma tarefa por enquanto...")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 6, 36, 61),
        child: const Icon(Icons.add),
      ),
    );
  }
}
