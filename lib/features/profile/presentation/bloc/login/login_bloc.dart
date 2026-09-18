import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tennis_scheduler/features/profile/domain/usecases/flowmanager/studentflowmanager.dart';
import '../../../../../core/util/result.dart';
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

    final result = await loginUserUseCase(event.email, event.password);

    switch (result) {
      case Success(data: final user):
        if (user.email == 'admin@tennis.com') {
          emit(LoginSuccess(user)); // El admin pasa directo
        } else {
          final hasLesson = await studentFlowManager.hasAssignedLesson(user.id);
          emit(LoginSuccess(user, needsOnboarding: !hasLesson));
        }
      case Failure(message: final errorMsg):
        emit(LoginError(errorMsg));
    }
  }

  Future<void> _onRegister(SubmitRegisterIntent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    final result = await registerUserUseCase(event.email, event.password, event.name);

    switch (result) {
      case Success(data: final isSuccess):
        if (isSuccess) {
          emit(RegisterSuccess());
        } else {
          emit(LoginError('No se pudo registrar el usuario'));
        }
      case Failure(message: final errorMsg):
        emit(LoginError(errorMsg));
    }
  }
}