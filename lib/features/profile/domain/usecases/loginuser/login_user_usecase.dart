import '../../entity/user_entity.dart';
import '../../repositories/repository_login_user.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUserUseCase {
  final RepositoryLoginUser repository;

  LoginUserUseCase(this.repository);

  Future<UserEntity?> call(String email, String password) {
    return repository.login(email, password);
  }
}