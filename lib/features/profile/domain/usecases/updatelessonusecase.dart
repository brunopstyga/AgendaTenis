import 'package:injectable/injectable.dart';
import '../../../../core/util/result.dart';
import '../../domain/repositories/i_lesson_repository.dart';

@injectable
class UpdateLessonUseCase {
  final ILessonRepository _repository;

  UpdateLessonUseCase(this._repository);

  Future<Result<void>> call({
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
  }) async {
    return await _repository.updateLesson(
      id: id,
      userId: userId,
      title: title,
      date: date,
      timeSlot: timeSlot,
      totalSpots: totalSpots,
      availableSpots: availableSpots,
      isBooked: isBooked,
      studentName: studentName,
      studentPhone: studentPhone,
      studentEmail: studentEmail,
      price: price,
      level: level,
      classType: classType,
    );
  }
}