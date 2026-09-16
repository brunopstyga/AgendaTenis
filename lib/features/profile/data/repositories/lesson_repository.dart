import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/lesson_slots_dao.dart';
import '../../domain/repositories/i_lesson_repository.dart';

@LazySingleton(as: ILessonRepository)
class LessonRepository implements ILessonRepository {
  final LessonSlotsDao _lessonSlotsDao;

  LessonRepository(this._lessonSlotsDao);

  // Obtener flujo de turnos en tiempo real para la UI
  @override
  Stream<List<LessonSlot>> watchSlots() {
    return _lessonSlotsDao.watchAllSlots();
  }

  // Obtener una lista única de turnos
  @override
  Future<List<LessonSlot>> getSlots() {
    return _lessonSlotsDao.getAllSlots();
  }

  // Agregar un nuevo turno o bloque
  @override
  Future<void> addSlot({
    required String id,
    int? userId,
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
  }) async {
    final companion = LessonSlotsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      date: Value(date),
      timeSlot: Value(timeSlot),
      totalSpots5: Value(totalSpots),
      availableSpots: Value(availableSpots),
      isBooked: Value(isBooked),
      studentName: Value(studentName),
      studentPhone: Value(studentPhone),
      studentEmail: Value(studentEmail),
      price: Value(price),
    );
    await _lessonSlotsDao.insertSlot(companion);
  }

  @override
  Future<void> updateLesson({
    required String id,
    int? userId,
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
  }) async {
    final lessonSlot = LessonSlot(
      id: id,
      userId: userId,
      title: title,
      date: date,
      timeSlot: timeSlot,
      totalSpots5: totalSpots,
      availableSpots: availableSpots,
      isBooked: isBooked,
      studentName: studentName,
      studentPhone: studentPhone,
      studentEmail: studentEmail,
      price: price,
    );
    await _lessonSlotsDao.updateSlot(lessonSlot);
  }

  // Eliminar un turno por su ID
  @override
  Future<void> deleteSlot(String id) async {
    await _lessonSlotsDao.deleteSlot(id);
  }
}