import '../entity/user_entity.dart';

abstract class RepositoryLoginUser {
  Future<UserEntity?> login(String email, String password);
  Future<bool> register(String email, String password, String? name);
}