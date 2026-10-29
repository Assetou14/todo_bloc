import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'todos/bloc/todos_bloc.dart';
import 'todos/view/todos_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Stockage local utilisé par HydratedBloc pour garder les tâches.
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  // Seul endroit de l'app où une couleur est choisie.
  static const _seedColor = Colors.indigo;

  @override
  Widget build(BuildContext context) {
    // Le Bloc est créé au-dessus de MaterialApp pour être accessible
    // depuis tous les écrans, y compris la page d'édition.
    return BlocProvider(
      create: (_) => TodosBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ma liste de tâches',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: _seedColor,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const TodosPage(),
      ),
    );
  }
}
