import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todos_bloc.dart';
import '../bloc/todos_event.dart';
import '../bloc/todos_state.dart';
import 'widgets/todo_input.dart';
import 'widgets/todo_list.dart';
import 'widgets/todos_footer.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Le SnackBar est un effet de bord : il va dans un BlocListener.
    return BlocListener<TodosBloc, TodosState>(
      listenWhen: (previous, current) =>
          current.lastDeletedTodo != null &&
          previous.lastDeletedTodo != current.lastDeletedTodo,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: const Text('Tâche supprimée'),
              // Avec une action, le SnackBar reste affiché par défaut :
              // on force sa disparition automatique après 7 s.
              duration: const Duration(seconds: 7),
              persist: false,
              action: SnackBarAction(
                label: 'Annuler',
                onPressed: () =>
                    context.read<TodosBloc>().add(const TodoDeletionUndone()),
              ),
            ),
          );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ma liste de tâches'),
          centerTitle: true,
        ),
        // SafeArea évite que le pied de page passe sous la barre de
        // navigation Android (edge-to-edge). L'AppBar gère déjà le haut.
        body: const SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(16), child: TodoInput()),
              Expanded(child: TodoList()),
              Padding(padding: EdgeInsets.all(12), child: TodosFooter()),
            ],
          ),
        ),
      ),
    );
  }
}
