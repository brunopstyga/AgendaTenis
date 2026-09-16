import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_intent.dart';
import '../bloc/login/login_state.dart';
import 'lessons_pages.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isRegistering ? 'Registro de Usuario' : 'Iniciar Sesión')),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('¡Bienvenido ${state.user.email}!')),
            );

            // Navega a la LessonsPage limpiando el historial y pasando el usuario logueado
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