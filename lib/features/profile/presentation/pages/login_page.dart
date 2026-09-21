import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_intent.dart';
import '../bloc/login/login_state.dart';
import '../components/login_form_widget.dart';
import '../util/login_navigation_handler.dart';


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

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isRegistering = false;

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
            LoginNavigationHandler.handleLoginSuccess(context, state);
          } else if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('¡Registro exitoso! Ya puedes iniciar sesión.')),
            );
            setState(() => _isRegistering = false);
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return LoginFormWidget(
            isRegistering: _isRegistering,
            emailController: _emailController,
            passwordController: _passwordController,
            nameController: _nameController,
            isLoading: isLoading,
            onSubmit: () => _submit(context),
            onToggleMode: () => setState(() => _isRegistering = !_isRegistering),
          );
        },
      ),
    );
  }
}