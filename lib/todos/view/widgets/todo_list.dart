import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/todos_bloc.dart';
import '../../bloc/todos_state.dart';
import 'todo_tile.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosBloc, TodosState>(
      builder: (context, state) {
        final todos = state.visibleTodos;

        if (todos.isEmpty) {
          return _buildEmptyMessage(context, state.filter);
        }

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return TodoTile(key: ValueKey(todo.id), todo: todo);
          },
        );
      },
    );
  }

  // État vide (F8), adapté au filtre actif.
  Widget _buildEmptyMessage(BuildContext context, TodosFilter filter) {
    final theme = Theme.of(context);
    final message = switch (filter) {
      TodosFilter.all => 'Aucune tâche pour le moment',
      TodosFilter.active => 'Aucune tâche en cours',
      TodosFilter.completed => 'Aucune tâche terminée',
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(message, style: theme.textTheme.titleMedium),
          if (filter == TodosFilter.all)
            const Text('Ajoutez une tâche pour commencer.'),
        ],
      ),
    );
  }
}
