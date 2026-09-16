// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_dao.dart';

// ignore_for_file: type=lint
mixin _$LoginDaoMixin on DatabaseAccessor<AppDatabase> {
  $LoginUsersTable get loginUsers => attachedDatabase.loginUsers;
  LoginDaoManager get managers => LoginDaoManager(this);
}

class LoginDaoManager {
  final _$LoginDaoMixin _db;
  LoginDaoManager(this._db);
  $$LoginUsersTableTableManager get loginUsers =>
      $$LoginUsersTableTableManager(_db.attachedDatabase, _db.loginUsers);
}
