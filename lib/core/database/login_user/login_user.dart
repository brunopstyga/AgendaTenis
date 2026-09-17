import 'package:cloud_firestore/cloud_firestore.dart';

class LoginUser {
  final String id;
  final String email;
  final String password;
  final String? name;
  final DateTime? createdAt;

  const LoginUser({
    required this.id,
    required this.email,
    required this.password,
    this.name,
    this.createdAt,
  });

  // 1. Crear el objeto a partir de un documento de Firestore
  factory LoginUser.fromFirestore(Map<String, dynamic> data, String documentId) {
    return LoginUser(
      id: documentId,
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      name: data['name'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // 2. Convertir el objeto a Map para guardarlo en Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Opcional: método copyWith por si lo usas en estados de BLoC
  LoginUser copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    DateTime? createdAt,
  }) {
    return LoginUser(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}