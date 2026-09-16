import '../repositories/i_lesson_repository.dart';
import 'package:injectable/injectable.dart';


@injectable
class DeleteLessonUseCase {
  final ILessonRepository _repository;

  DeleteLessonUseCase(this._repository);

  Future<void> call(String id) async {
    return _repository.deleteSlot(id);
  }
}