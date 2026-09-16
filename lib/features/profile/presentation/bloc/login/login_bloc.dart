import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tennis_scheduler/features/profile/domain/usecases/flowmanager/studentflowmanager.dart';
import '../../../domain/usecases/loginuser/login_user_usecase.dart';
import '../../../domain/usecases/loginuser/register_user_usecase.dart';
import 'login_intent.dart';
import 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginIntent, LoginState> {
  final LoginUserUseCase loginUserUseCase;
  final RegisterUserUseCase registerUserUseCase;
  final StudentFlowManager studentFlowManager;

  LoginBloc({
    required this.loginUserUseCase,
    required this.registerUserUseCase,
    required this.studentFlowManager,
  }) : super(LoginInitial()) {
    on<SubmitLoginIntent>(_onLogin);
    on<SubmitRegisterIntent>(_onRegister);
  }

  Future<void> _onLogin(SubmitLoginIntent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await loginUserUseCase(event.email, event.password);
      if (user != null) {
        // 2. Evaluamos si es el administrador
        if (user.email == 'admin@tennis.com') {
          emit(LoginSuccess(user)); // El admin pasa directo
        } else {
          // 3. Si es alumno, verificamos si ya tiene lecciones asignadas
          final hasLesson = await studentFlowManager.hasAssignedLesson(user.id);

          // Emitimos el éxito indicando si requiere el modal de onboarding
          emit(LoginSuccess(user, needsOnboarding: !hasLesson));
        }
      } else {
        emit(LoginError('Correo o contraseña incorrectos'));
      }
    } catch (e) {
      emit(LoginError('Ocurrió un error al iniciar sesión: $e'));
    }
  }

  Future<void> _onRegister(SubmitRegisterIntent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final success = await registerUserUseCase(event.email, event.password, event.name);
      if (success) {
        emit(RegisterSuccess());
      } else {
        emit(LoginError('No se pudo registrar el usuario (quizá ya exista)'));
      }
    } catch (e) {
      emit(LoginError('Ocurrió un error en el registro: $e'));
    }
  }
}