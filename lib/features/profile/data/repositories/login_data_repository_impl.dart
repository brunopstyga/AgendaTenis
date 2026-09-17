import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repositories/repository_login_user.dart';

@LazySingleton(as: RepositoryLoginUser)
class LoginDataRepositoryImpl implements RepositoryLoginUser {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserEntity?> login(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (credential.user == null) return null;

      // Buscamos el documento en Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) return null;

      // 🚀 Reutilizamos nuestro factory fromMap para construir la entidad
      return UserEntity.fromMap(
        userDoc.data() as Map<String, dynamic>,
        userDoc.id,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> register(String email, String password, String? name) async {
    try {
      // 1. Crear el usuario en Firebase Authentication
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? firebaseUser = credential.user;
      if (firebaseUser == null) return false;

      // 2. Guardar perfil en Firestore usando el UID como ID del documento
      await _firestore.collection('users').doc(firebaseUser.uid).set({
        'uid': firebaseUser.uid,
        'email': email.trim(),
        'name': name ?? 'Usuario',
        'isTeacher': false, // Por defecto los nuevos registros son alumnos
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (_) {
      return false;
    }
  }
}