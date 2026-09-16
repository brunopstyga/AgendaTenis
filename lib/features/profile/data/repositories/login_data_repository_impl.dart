import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/login_user/login_dao.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repositories/repository_login_user.dart';
import 'package:injectable/injectable.dart';




@LazySingleton(as: RepositoryLoginUser)
class LoginDataRepositoryImpl implements RepositoryLoginUser {
  final LoginDao _loginDao;

  LoginDataRepositoryImpl(this._loginDao);

  @override
  Future<UserEntity?> login(String email, String password) async {
    final user = await _loginDao.getUserByEmail(email);
    if (user != null && user.password == password) {
      return UserEntity(
        id: user.id,
        email: user.email,
        name: user.name,
      );
    }
    return null; // Credenciales inválidas
  }

  @override
  Future<bool> register(String email, String password, String? name) async {
    try {
      final existing = await _loginDao.getUserByEmail(email);
      if (existing != null) return false; // Ya existe

      await _loginDao.insertUser(
        LoginUsersCompanion.insert(
          email: email,
          password: password,
          name: Value(name),
          createdAt: Value(DateTime.now()),
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}