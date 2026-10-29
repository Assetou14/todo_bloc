import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/todos_bloc.dart';
import '../../bloc/todos_event.dart';
import '../../bloc/todos_state.dart';

class TodosFooter extends StatelessWidget {
  const TodosFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosBloc, TodosState>(
      // Ne se reconstruit que si le compteur, le filtre ou le bouton changent.
      buildWhen: (previous, current) =>
          previous.activeCount != current.activeCount ||
          previous.filter != current.filter ||
          previous.hasCompletedTodos != current.hasCompletedTodos,
      builder: (context, state) {
        final bloc = context.read<TodosBloc>();
        final count = state.activeCount;
        // En français, 0 et 1 restent au singulier (F6).
        final countLabel = count <= 1
            ? '$count tâche restante'
            : '$count tâches restantes';

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(countLabel),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                for (final filter in TodosFilter.values)
                  ChoiceChip(
                    label: Text(_filterLabel(filter)),
                    selected: state.filter == filter,
                    onSelected: (_) => bloc.add(TodosFilterChanged(filter)),
                  ),
              ],
            ),
            if (state.hasCompletedTodos)
              TextButton.icon(
                onPressed: () => bloc.add(const CompletedTodosCleared()),
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text('Vider les terminées'),
              ),
          ],
        );
      },
    );
  }

  String _filterLabel(TodosFilter filter) {
    return switch (filter) {
      TodosFilter.all => 'Toutes',
      TodosFilter.active => 'En cours',
      TodosFilter.completed => 'Terminées',
    };
  }
}
