
import 'login_user/login_user.dart';

class LessonSlot {
  final String id;
  final String userId;
  final String title;
  final String date;
  final String timeSlot;
  final int totalSpots;
  final int availableSpots;
  final bool isBooked;
  final String? studentName;
  final String? studentPhone;
  final String? studentEmail;
  final double price;
  final String level;
  final String classType;

  const LessonSlot({
    required this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.timeSlot,
    required this.totalSpots,
    required this.availableSpots,
    required this.isBooked,
    this.studentName,
    this.studentPhone,
    this.studentEmail,
    required this.price,
    required this.level,
    required this.classType,
  });

  // Convertir desde un documento de Firebase Firestore
  factory LessonSlot.fromFirestore(Map<String, dynamic> data, String documentId) {
    return LessonSlot(
      id: documentId,
      userId: data['userId'],
      title: data['title'] ?? '',
      date: data['date'] ?? '',
      timeSlot: data['timeSlot'] ?? '',
      totalSpots: data['totalSpots'] ?? 4,
      availableSpots: data['availableSpots'] ?? 3,
      isBooked: data['isBooked'] ?? false,
      studentName: data['studentName'],
      studentPhone: data['studentPhone'],
      studentEmail: data['studentEmail'],
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      level: data['level'] ?? 'Básico',
      classType: data['classType'] ?? 'Grupal',
    );
  }

  // Convertir a un Map para enviarlo a Firestore
  Map<String, dynamic> toMap() {
    return {
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
      'level': level,
      'classType': classType,
    };
  }
}