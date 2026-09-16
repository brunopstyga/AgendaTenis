import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'features/profile/presentation/bloc/lessons_bloc.dart';
import 'features/profile/presentation/bloc/login/login_bloc.dart';
import 'features/profile/presentation/pages/lessons_pages.dart';
import 'features/profile/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      home: BlocProvider(
        create: (context) => getIt<LoginBloc>(),
        child: const LoginPage(),
      ),
    );
  }
}