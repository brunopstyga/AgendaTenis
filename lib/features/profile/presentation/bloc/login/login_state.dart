

import '../../../domain/entity/user_entity.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;
  LoginSuccess(this.user);
}

class RegisterSuccess extends LoginState {}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}