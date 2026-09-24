import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_intent.dart';
import '../bloc/login/login_state.dart';
import '../components/app_snack_bar.dart';
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
      AppSnackBar.show(
        context,
        AppStrings.fillMandatoryFieldsError,
        isError: true,
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
      appBar: AppBar(title: Text(_isRegistering ? AppStrings.registerTitle : AppStrings.loginTitle),
      centerTitle: true,),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            LoginNavigationHandler.handleLoginSuccess(context, state);
          } else if (state is RegisterSuccess) {
            AppSnackBar.show(context, AppStrings.registerSuccessMsg);
            setState(() => _isRegistering = false);
          } else if (state is LoginError) {
                AppSnackBar.show(context, state.message, isError: true);
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