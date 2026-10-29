import 'package:equatable/equatable.dart';

import 'todos_state.dart';

sealed class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object?> get props => [];
}

// Ajouter une tâche (F1)
final class TodoAdded extends TodosEvent {
  const TodoAdded(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

// Marquer une tâche comme terminée ou non terminée (F2)
final class TodoToggled extends TodosEvent {
  const TodoToggled(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

// Supprimer une tâche (F3)
final class TodoDeleted extends TodosEvent {
  const TodoDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

// Annuler la dernière suppression (bonus)
final class TodoDeletionUndone extends TodosEvent {
  const TodoDeletionUndone();
}

// Modifier le titre d'une tâche (F4)
final class TodoEdited extends TodosEvent {
  const TodoEdited({required this.id, required this.title});

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}

// Filtrer les tâches (F5)
final class TodosFilterChanged extends TodosEvent {
  const TodosFilterChanged(this.filter);

  final TodosFilter filter;

  @override
  List<Object?> get props => [filter];
}

// Supprimer toutes les tâches terminées (F7)
final class CompletedTodosCleared extends TodosEvent {
  const CompletedTodosCleared();
}
