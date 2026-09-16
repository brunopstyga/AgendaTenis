import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'features/profile/presentation/bloc/lessons_bloc.dart';
import 'features/profile/presentation/pages/lessons_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos GetIt con el código generado por injectable
  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tennis Scheduler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Obtenemos el Bloc automáticamente mediante GetIt
      home: BlocProvider(
        create: (context) => getIt<LessonsBloc>(),
        child: const LessonsPage(),
      ),
    );
  }
}