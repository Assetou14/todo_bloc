import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todos_bloc.dart';
import '../bloc/todos_event.dart';
import '../models/todo.dart';

class TodoEditPage extends StatefulWidget {
  const TodoEditPage({super.key, required this.todo});

  static Route<void> route(Todo todo) {
    return MaterialPageRoute<void>(builder: (_) => TodoEditPage(todo: todo));
  }

  final Todo todo;

  @override
  State<TodoEditPage> createState() => _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.title);
  }

  void _save() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le titre ne peut pas être vide.')),
      );
      return;
    }

    final bloc = context.read<TodosBloc>();
    if (bloc.state.hasTodoWithTitle(
      _controller.text,
      exceptId: widget.todo.id,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une tâche porte déjà ce titre.')),
      );
      return;
    }

    // Le Bloc est créé au-dessus de MaterialApp : il est accessible ici.
    bloc.add(TodoEdited(id: widget.todo.id, title: _controller.text));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier la tâche')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Titre de la tâche',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Enregistrer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
