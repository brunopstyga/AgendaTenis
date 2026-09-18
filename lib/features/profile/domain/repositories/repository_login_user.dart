import '../../../../core/util/result.dart';
import '../entity/user_entity.dart';

abstract class RepositoryLoginUser {
  Future<Result<UserEntity>> login(String email, String password);

  Future<Result<bool>> register(String email, String password, String? name);
}