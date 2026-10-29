import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/todos_bloc.dart';
import '../../bloc/todos_event.dart';
import '../../models/todo.dart';
import '../todo_edit_page.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bloc = context.read<TodosBloc>();

    return Dismissible(
      key: ValueKey('dismissible-${todo.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => bloc.add(TodoDeleted(todo.id)),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: colorScheme.errorContainer,
        child: Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
      ),
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: todo.isDone,
            onChanged: (_) => bloc.add(TodoToggled(todo.id)),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: todo.isDone ? colorScheme.outline : null,
            ),
          ),
          // Un appui ouvre l'écran d'édition (F4).
          onTap: () => Navigator.of(context).push(TodoEditPage.route(todo)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Modifier',
                onPressed: () =>
                    Navigator.of(context).push(TodoEditPage.route(todo)),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Supprimer',
                onPressed: () => bloc.add(TodoDeleted(todo.id)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
