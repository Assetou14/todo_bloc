import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../models/todo.dart';
import 'todos_event.dart';
import 'todos_state.dart';

class TodosBloc extends HydratedBloc<TodosEvent, TodosState> {
  TodosBloc({super.storage}) : super(const TodosState()) {
    on<TodoAdded>(_onTodoAdded);
    on<TodoToggled>(_onTodoToggled);
    on<TodoDeleted>(_onTodoDeleted);
    on<TodoDeletionUndone>(_onTodoDeletionUndone);
    on<TodoEdited>(_onTodoEdited);
    on<TodosFilterChanged>(_onFilterChanged);
    on<CompletedTodosCleared>(_onCompletedCleared);
  }

  void _onTodoAdded(TodoAdded event, Emitter<TodosState> emit) {
    final title = event.title.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final todo = Todo(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      createdAt: now,
    );

    emit(state.copyWith(todos: [...state.todos, todo]));
  }

  void _onTodoToggled(TodoToggled event, Emitter<TodosState> emit) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(isDone: !todo.isDone);
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  void _onTodoDeleted(TodoDeleted event, Emitter<TodosState> emit) {
    final index = state.todos.indexWhere((todo) => todo.id == event.id);
    if (index == -1) return;

    emit(
      TodosState(
        todos: state.todos.where((todo) => todo.id != event.id).toList(),
        filter: state.filter,
        lastDeletedTodo: state.todos[index],
        lastDeletedIndex: index,
      ),
    );
  }

  void _onTodoDeletionUndone(
    TodoDeletionUndone event,
    Emitter<TodosState> emit,
  ) {
    final deletedTodo = state.lastDeletedTodo;
    final index = state.lastDeletedIndex;
    if (deletedTodo == null || index == null) return;

    // Remet la tâche à sa position d'origine.
    final restoredTodos = [...state.todos]
      ..insert(index.clamp(0, state.todos.length), deletedTodo);

    emit(TodosState(todos: restoredTodos, filter: state.filter));
  }

  void _onTodoEdited(TodoEdited event, Emitter<TodosState> emit) {
    final title = event.title.trim();
    if (title.isEmpty) return;

    final updatedTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(title: title);
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  void _onFilterChanged(TodosFilterChanged event, Emitter<TodosState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onCompletedCleared(
    CompletedTodosCleared event,
    Emitter<TodosState> emit,
  ) {
    emit(
      state.copyWith(todos: state.todos.where((todo) => !todo.isDone).toList()),
    );
  }

  // Persistance (bonus) : seules les tâches sont sauvegardées.
  @override
  TodosState? fromJson(Map<String, dynamic> json) {
    final todos = (json['todos'] as List<dynamic>)
        .map((item) => Todo.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
    return TodosState(todos: todos);
  }

  @override
  Map<String, dynamic>? toJson(TodosState state) {
    return {'todos': state.todos.map((todo) => todo.toJson()).toList()};
  }
}
