
import 'package:injectable/injectable.dart';
import '../../../../../core/util/result.dart';
import '../../repositories/AvailabilityRepository.dart';
@injectable
class SaveScheduleUseCase {
  final AvailabilityRepository _repository;

  SaveScheduleUseCase(this._repository);

  Future<Result<void>> call(Map<String, Map<String, dynamic>> schedule) async {
    return await _repository.saveSchedule(schedule);
  }
}