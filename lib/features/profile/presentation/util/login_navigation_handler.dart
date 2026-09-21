
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';

import '../bloc/lessons_bloc.dart';
import '../bloc/login/login_state.dart';
import '../pages/lessons_pages.dart';
import '../pages/onboarding_page.dart';


class LoginNavigationHandler {
  static void handleLoginSuccess(BuildContext context, LoginSuccess state) {
    if (state.user.email == 'admin@tennis.com') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Bienvenido Administrador!')),
      );
      _navigateTo(context, LessonsPage(currentUser: state.user));
    } else if (state.needsOnboarding) {
      _navigateTo(context, OnboardingPage(user: state.user));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Bienvenido ${state.user.email}!')),
      );
      _navigateTo(context, LessonsPage(currentUser: state.user));
    }
  }

  static void _navigateTo(BuildContext context, Widget destinationPage) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<LessonsBloc>(),
          child: destinationPage,
        ),
      ),
          (route) => false,
    );
  }
}