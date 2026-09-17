// lib/core/services/notification_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendBookingNotificationToTeacher({
    required String studentName,
    required String lessonDate,
    required String timeSlot,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'title': '¡Nuevo turno reservado!',
        'message': 'El alumno $studentName reservó la clase del día $lessonDate a las $timeSlot.',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      // Manejo de error opcional
    }
  }
}