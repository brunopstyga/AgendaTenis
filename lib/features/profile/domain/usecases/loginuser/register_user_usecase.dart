
import 'package:injectable/injectable.dart';
import '../../repositories/repository_login_user.dart';

@injectable
class RegisterUserUseCase {
  final RepositoryLoginUser repository;

  RegisterUserUseCase(this.repository);

  Future<bool> call(String email, String password, String? name) {
    return repository.register(email, password, name);
  }
}