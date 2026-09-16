import '../../../../core/database/app_database.dart';
import '../repositories/i_lesson_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchLessonsUseCase {
  final ILessonRepository _repository;

  WatchLessonsUseCase(this._repository);

  Stream<List<LessonSlot>> call() {
    return _repository.watchSlots();
  }
}