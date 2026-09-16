import 'package:injectable/injectable.dart';
import '../repositories/i_lesson_repository.dart';

@injectable
class AddLessonUseCase {
  final ILessonRepository _repository;

  AddLessonUseCase(this._repository);

  Future<void> call({
    required String id,
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
  }) {
    return _repository.addSlot(
      id: id,
      title: title,
      date: date,
      timeSlot: timeSlot,
      totalSpots: totalSpots,
      availableSpots: availableSpots,
      isBooked: isBooked,
      studentName: studentName,
      studentPhone: studentPhone,
      studentEmail: studentEmail,
      price: 0.0,
    );
  }
}