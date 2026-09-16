

import '../../../domain/entity/user_entity.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;
  final bool needsOnboarding;
  LoginSuccess(this.user, {this.needsOnboarding = false});
}

class RegisterSuccess extends LoginState {}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}