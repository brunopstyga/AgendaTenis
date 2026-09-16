import 'package:drift/drift.dart';
import '../app_database.dart';
import 'login_user.dart';

part 'login_dao.g.dart';

@DriftAccessor(tables: [LoginUsers])
class LoginDao extends DatabaseAccessor<AppDatabase> with _$LoginDaoMixin {
  LoginDao(AppDatabase db) : super(db);

  Future<LoginUser?> getUserByEmail(String email) =>
      (select(loginUsers)..where((t) => t.email.equals(email))).getSingleOrNull();

  Future<int> insertUser(LoginUsersCompanion user) =>
      into(loginUsers).insert(user);
}