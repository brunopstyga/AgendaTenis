import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/lesson_slots_table.dart';
import '../../../../core/util/result.dart';
import '../../domain/repositories/i_lesson_repository.dart';

@LazySingleton(as: ILessonRepository)
class LessonRepository implements ILessonRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'classes';

  // Los Stream se pueden mantener devolviendo el stream directo por naturaleza reactiva de Firestore
  @override
  Stream<List<LessonSlot>> watchSlots() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return LessonSlot(
          id: doc.id,
          userId: data['userId'],
          title: data['title'] ?? '',
          date: data['date'] ?? '',
          timeSlot: data['timeSlot'] ?? '',
          totalSpots: int.tryParse(data['totalSpots']?.toString() ?? '') ?? 4,
          availableSpots: int.tryParse(data['availableSpots']?.toString() ?? '') ?? 3,
          isBooked: data['isBooked'] ?? true,
          studentName: data['studentName'],
          studentPhone: data['studentPhone'],
          studentEmail: data['studentEmail'],
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          level: data['level'] ?? 'Básico',
          classType: data['classType'] ?? 'Grupal',
        );
      }).toList();
    });
  }

  @override
  Future<Result<List<LessonSlot>>> getSlots() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final slots = snapshot.docs.map((doc) {
        final data = doc.data();
        return LessonSlot(
          id: doc.id,
          userId: data['userId'],
          title: data['title'] ?? '',
          date: data['date'] ?? '',
          timeSlot: data['timeSlot'] ?? '',
          totalSpots: int.tryParse(data['totalSpots']?.toString() ?? '') ?? 4,
          availableSpots: int.tryParse(data['availableSpots']?.toString() ?? '') ?? 3,
          isBooked: data['isBooked'] ?? true,
          studentName: data['studentName'],
          studentPhone: data['studentPhone'],
          studentEmail: data['studentEmail'],
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          level: data['level'] ?? 'Básico',
          classType: data['classType'] ?? 'Grupal',
        );
      }).toList();
      return Success(slots);
    } catch (e) {
      return Failure('Error al obtener los turnos: $e');
    }
  }

  @override
  Future<Result<void>> addSlot({
    required String id,
    required String userId,
    required String title,
    required String date,
    required String timeSlot,
    required int totalSpots,
    required int availableSpots,
    required bool isBooked,
    String? studentName,
    String? studentPhone,
    String? studentEmail,
    required double price,
    String? level,
    String? classType,
  }) async {
    try {
      await _firestore.collection(_collection).doc(id).set({
        'userId': userId,
        'title': title,
        'date': date,
        'timeSlot': timeSlot,
        'totalSpots': totalSpots,
        'availableSpots': availableSpots,
        'isBooked': isBooked,
        'studentName': studentName,
        'studentPhone': studentPhone,
        'studentEmail': studentEmail,
        'price': price,
        'level': level ?? 'Básico',
        'classType': classType ?? 'Grupal',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return const Success(null);
    } catch (e) {
      return Failure('Error al agregar el turno: $e');
    }
  }

  @override
  Future<Result<void>> updateLesson({
    required String id,
    required String userId,
    required String title,
    required String date,
    required String timeSlot,
    required int totalSpots,
    required int availableSpots,
    required bool isBooked,
    String? studentName,
    String? studentPhone,
    String? studentEmail,
    required double price,
    String? level,
    String? classType,
  }) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'userId': userId,
        'title': title,
        'date': date,
        'timeSlot': timeSlot,
        'totalSpots': totalSpots,
        'availableSpots': availableSpots,
        'isBooked': isBooked,
        'studentName': studentName,
        'studentPhone': studentPhone,
        'studentEmail': studentEmail,
        'price': price,
        'level': level ?? 'Básico',
        'classType': classType ?? 'Grupal',
      });
      return const Success(null);
    } catch (e) {
      return Failure('Error al actualizar el turno: $e');
    }
  }

  @override
  Future<Result<void>> deleteSlot(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      return const Success(null);
    } catch (e) {
      return Failure('Error al eliminar el turno: $e');
    }
  }
}