import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:tennis_scheduler/core/constants/app_strings.dart';
import '../../../../core/util/result.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repositories/repository_login_user.dart';

@LazySingleton(as: RepositoryLoginUser)
class LoginDataRepositoryImpl implements RepositoryLoginUser {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<UserEntity>> login(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (credential.user == null) {
        return const Failure(AppStrings.authNotFoundFailure);
      }

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        return const Failure(AppStrings.userDocNotFoundFailure);
      }

      final userEntity = UserEntity.fromMap(
        userDoc.data() as Map<String, dynamic>,
        userDoc.id,
      );

      return Success(userEntity);
    } catch (e) {
      return Failure('${AppStrings.notCreateSesion}: $e');
    }
  }

  @override
  Future<Result<bool>> register(String email, String password, String? name) async {
    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? firebaseUser = credential.user;
      if (firebaseUser == null) {
        return const Failure(AppStrings.authNotFoundFailure);
      }

      await _firestore.collection('users').doc(firebaseUser.uid).set({
        'uid': firebaseUser.uid,
        'email': email.trim(),
        'name': name ?? 'Usuario',
        'isTeacher': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return const Success(true);
    } catch (e) {
      return Failure('${AppStrings.errorRegister}: $e');
    }
  }
}