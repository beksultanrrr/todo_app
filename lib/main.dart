import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/services/repositories/task_repository.dart';
import 'package:todo_app/screens/main_screen/bloc/home_bloc.dart';
import 'package:todo_app/screens/main_screen/main_screen.dart';
import 'package:get_it/get_it.dart';

void setup() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.instance.registerLazySingleton<TaskRepository>(() => TaskRepository());
}

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(providers: [
        BlocProvider<HomeBloc>(create: (context) => HomeBloc(GetIt.I.get<TaskRepository>())),
      ], child: const MainScreen()),
    );
  }
}
