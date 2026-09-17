import '../../../../core/database/lesson_slots_table.dart';

abstract class ILessonRepository {
  Stream<List<LessonSlot>> watchSlots();
  Future<List<LessonSlot>> getSlots();
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
    required String level,
    required String classType,
  });
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
  required String level,
  required String classType,
});
Future<void> deleteSlot(String id);
}