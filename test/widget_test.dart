import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc/main.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  setUp(() {
    final storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  testWidgets('L’application Todo démarre', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());

    expect(find.text('Ma liste de tâches'), findsOneWidget);
    expect(find.text('Nouvelle tâche'), findsOneWidget);
    expect(find.text('0 tâche restante'), findsOneWidget);
  });
}
