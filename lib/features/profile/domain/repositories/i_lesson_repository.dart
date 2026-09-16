
import '../../../../core/database/app_database.dart';

abstract class ILessonRepository {
  Stream<List<LessonSlot>> watchSlots();
  Future<List<LessonSlot>> getSlots();
  Future<void> addSlot({
    required String id,
    required int? userId,
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
  });
Future<void> updateLesson({
  required String id,
  required int? userId,
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
});
Future<void> deleteSlot(String id);
}