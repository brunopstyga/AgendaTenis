import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/loginuser/login_user_usecase.dart';
import '../../../domain/usecases/loginuser/register_user_usecase.dart';
import 'login_intent.dart';
import 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginIntent, LoginState> {
  final LoginUserUseCase loginUserUseCase;
  final RegisterUserUseCase registerUserUseCase;

  LoginBloc({
    required this.loginUserUseCase,
    required this.registerUserUseCase,
  }) : super(LoginInitial()) {
    on<SubmitLoginIntent>(_onLogin);
    on<SubmitRegisterIntent>(_onRegister);
  }

  Future<void> _onLogin(SubmitLoginIntent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await loginUserUseCase(event.email, event.password);
      if (user != null) {
        emit(LoginSuccess(user));
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