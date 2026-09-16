abstract class LoginIntent {}

class SubmitLoginIntent extends LoginIntent {
  final String email;
  final String password;

  SubmitLoginIntent({required this.email, required this.password});
}

class SubmitRegisterIntent extends LoginIntent {
  final String email;
  final String password;
  final String? name;

  SubmitRegisterIntent({required this.email, required this.password, this.name});
}