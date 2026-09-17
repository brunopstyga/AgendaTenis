import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/lesson_slots_table.dart';
import '../../domain/repositories/i_lesson_repository.dart';

@LazySingleton(as: ILessonRepository)
class LessonRepository implements ILessonRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'classes';


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

  // Obtener una lista única de turnos desde Firebase
  @override
  Future<List<LessonSlot>> getSlots() async {
    final snapshot = await _firestore.collection(_collection).get();
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
  }

  // Agregar un nuevo turno en la nube (El camino de ida + disparador de notificación)
  @override
  Future<void> addSlot({
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
  }

  // Actualizar un turno existente en la nube
  @override
  Future<void> updateLesson({
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
  }

  // Eliminar un turno por su ID en la nube
  @override
  Future<void> deleteSlot(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}