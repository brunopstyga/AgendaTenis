import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_intent.dart';
import '../bloc/login/login_state.dart';
import '../components/student_modal_form.dart';
import 'lessons_pages.dart';
import 'onboarding_page.dart';

// 1. Clase contenedora que provee el LoginBloc antes de dibujar la vista
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

// 2. Vista interna con toda tu lógica y formularios intactos
class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isRegistering = false; // Alternar entre Login y Registro

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa los campos obligatorios')),
      );
      return;
    }

    if (_isRegistering) {
      context.read<LoginBloc>().add(
        SubmitRegisterIntent(email: email, password: password, name: name.isEmpty ? null : name),
      );
    } else {
      context.read<LoginBloc>().add(
        SubmitLoginIntent(email: email, password: password),
      );
    }
  }

  String _getCurrentDayName() {
    const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return days[DateTime.now().weekday - 1];
  }

  // Función para mostrar el modal obligatorio de onboarding a alumnos nuevos
  void _showMandatoryOnboardingModal(BuildContext context, String userId, String userEmail) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impide cerrar tocando fuera del modal
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (context) => getIt<LessonsBloc>(),
          child: Builder(
            builder: (innerContext) {
              return WillPopScope(
                onWillPop: () async => false, // Impide cerrar con el botón "Atrás"
                child: AlertDialog(
                  title: const Text('¡Bienvenido! Elige tu primer turno'),
                  content: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: StudentModalForm(
                        selectedDay: _getCurrentDayName(),
                        currentUserId: userId,
                        currentUserEmail: userEmail,
                        lessonsBloc: BlocProvider.of<LessonsBloc>(innerContext),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isRegistering ? 'Registro de Usuario' : 'Iniciar Sesión')),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // 1. Verificamos si es el Administrador
            if (state.user.email == 'admin@tennis.com') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Bienvenido Administrador!')),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => getIt<LessonsBloc>(),
                    child: LessonsPage(currentUser: state.user),
                  ),
                ),
                    (route) => false,
              );
            }
            // 2. Verificamos si es un alumno nuevo que necesita onboarding obligatorio
            else if (state.needsOnboarding) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => OnboardingPage(user: state.user),
                ),
                    (route) => false,
              );
            }
            // 3. Alumno existente que ya tiene turnos asignados
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('¡Bienvenido ${state.user.email}!')),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => getIt<LessonsBloc>(),
                    child: LessonsPage(currentUser: state.user),
                  ),
                ),
                    (route) => false,
              );
            }
          } else if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('¡Registro exitoso! Ya puedes iniciar sesión.')),
            );
            setState(() => _isRegistering = false); // Vuelve al modo login automáticamente
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isRegistering) ...[
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nombre (Opcional)', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () => _submit(context),
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                        child: Text(_isRegistering ? 'Registrarse' : 'Ingresar'),
                      ),
                    TextButton(
                      onPressed: () => setState(() => _isRegistering = !_isRegistering),
                      child: Text(_isRegistering
                          ? '¿Ya tienes una cuenta? Inicia sesión'
                          : '¿No tienes cuenta? Regístrate aquí'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}