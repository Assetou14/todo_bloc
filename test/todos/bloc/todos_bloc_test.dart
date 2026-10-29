import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc/todos/bloc/todos_bloc.dart';
import 'package:todo_bloc/todos/bloc/todos_event.dart';
import 'package:todo_bloc/todos/bloc/todos_state.dart';
import 'package:todo_bloc/todos/models/todo.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    // Faux stockage : chaque test démarre avec une liste vide.
    storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
  });

  group('TodosBloc', () {
    blocTest<TodosBloc, TodosState>(
      'TodoAdded avec un titre valide ajoute un élément',
      build: () => TodosBloc(storage: storage),
      act: (bloc) => bloc.add(const TodoAdded('  Réviser Flutter  ')),
      expect: () => [
        isA<TodosState>()
            .having((s) => s.todos.length, 'nombre de tâches', 1)
            .having((s) => s.todos.first.title, 'titre', 'Réviser Flutter')
            .having((s) => s.todos.first.isDone, 'isDone', isFalse),
      ],
    );

    blocTest<TodosBloc, TodosState>(
      'TodoAdded avec un titre composé d\'espaces n\'émet aucun état',
      build: () => TodosBloc(storage: storage),
      act: (bloc) => bloc.add(const TodoAdded('   ')),
      expect: () => <TodosState>[],
    );

    blocTest<TodosBloc, TodosState>(
      'TodoToggled puis CompletedTodosCleared vide la liste',
      build: () => TodosBloc(storage: storage),
      seed: () => TodosState(
        todos: [
          Todo(id: '1', title: 'Tâche', createdAt: DateTime(2026, 10, 26)),
        ],
      ),
      act: (bloc) => bloc
        ..add(const TodoToggled('1'))
        ..add(const CompletedTodosCleared()),
      expect: () => [
        isA<TodosState>().having(
          (s) => s.todos.single.isDone,
          'isDone',
          isTrue,
        ),
        isA<TodosState>().having((s) => s.todos, 'todos', isEmpty),
      ],
    );
  });
}
