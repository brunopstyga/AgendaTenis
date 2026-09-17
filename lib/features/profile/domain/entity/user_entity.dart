class UserEntity {
  final String id;
  final String email;
  final String? name;
  final bool isTeacher;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.isTeacher = false,
  });

  // 1. Para convertir tu entidad en un Map y guardarla en Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'email': email,
      'name': name,
      'isTeacher': isTeacher,
    };
  }

  // 2. Para crear una Entidad a partir de los datos que bajan de Firestore
  factory UserEntity.fromMap(Map<String, dynamic> map, String documentId) {
    return UserEntity(
      id: documentId,
      email: map['email'] ?? '',
      name: map['name'],
      isTeacher: map['isTeacher'] ?? false,
    );
  }
}