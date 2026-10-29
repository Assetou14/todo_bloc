import 'package:equatable/equatable.dart';

import '../models/todo.dart';

enum TodosFilter { all, active, completed }

class TodosState extends Equatable {
  const TodosState({
    this.todos = const [],
    this.filter = TodosFilter.all,
    this.lastDeletedTodo,
    this.lastDeletedIndex,
  });

  final List<Todo> todos;
  final TodosFilter filter;

  // Dernière tâche supprimée et sa position, pour le SnackBar « Annuler ».
  final Todo? lastDeletedTodo;
  final int? lastDeletedIndex;

  List<Todo> get visibleTodos {
    switch (filter) {
      case TodosFilter.all:
        return todos;
      case TodosFilter.active:
        return todos.where((todo) => !todo.isDone).toList();
      case TodosFilter.completed:
        return todos.where((todo) => todo.isDone).toList();
    }
  }

  int get activeCount => todos.where((todo) => !todo.isDone).length;

  bool get hasCompletedTodos => todos.any((todo) => todo.isDone);

  TodosState copyWith({List<Todo>? todos, TodosFilter? filter}) {
    return TodosState(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      lastDeletedTodo: lastDeletedTodo,
      lastDeletedIndex: lastDeletedIndex,
    );
  }

  @override
  List<Object?> get props => [todos, filter, lastDeletedTodo, lastDeletedIndex];
}
