import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'features/profile/domain/entity/user_entity.dart';
import 'features/profile/presentation/bloc/lessons_bloc.dart';
import 'features/profile/presentation/pages/lessons_pages.dart';
import 'features/profile/presentation/pages/login_page.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tennis Scheduler',
      theme: ThemeData(primarySwatch: Colors.green),
      // Usamos StreamBuilder para escuchar el estado de autenticación de Firebase en tiempo real
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Si está cargando el estado inicial de Firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Si hay un usuario logueado, lo mandamos directamente a la Agenda (LessonsPage)
          if (snapshot.hasData && snapshot.data != null) {
            final firebaseUser = snapshot.data!;
            // Creamos tu UserEntity a partir del usuario de Firebase
            final userEntity = UserEntity(
              id: firebaseUser.uid,
              email: firebaseUser.email ?? '',
              name: firebaseUser.displayName ?? 'Profesor/Usuario',
            );
            return BlocProvider(
              create: (context) => getIt<LessonsBloc>(),
              child: LessonsPage(currentUser: userEntity),
            );
          }

          // Si NO hay sesión activa, lo mandamos al Login
          return const LoginPage();
        },
      ),
    );
  }
}