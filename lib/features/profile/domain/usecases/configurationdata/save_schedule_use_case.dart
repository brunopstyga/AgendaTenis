
import 'package:injectable/injectable.dart';
import '../../repositories/AvailabilityRepository.dart';
@injectable
class SaveScheduleUseCase {
  final AvailabilityRepository _repository;

  SaveScheduleUseCase(this._repository);

  Future<void> call(Map<String, List<Map<String, dynamic>>> newSchedule) async {
    await _repository.saveSchedule(newSchedule);
  }
}