import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class StudentFlowManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StudentFlowManager();

  Future<bool> hasAssignedLesson(String userId) async {
    try {
      // Consultamos la colección 'classes' en Firestore donde el userId coincida
      final querySnapshot = await _firestore
          .collection('classes')
          .where('userId', isEqualTo: userId)
          .limit(1) // Solo necesitamos saber si existe al menos una
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}