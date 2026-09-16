class UserEntity {
  final int id;
  final String email;
  final String? name;
  final bool isTeacher;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.isTeacher = false,
  });
}