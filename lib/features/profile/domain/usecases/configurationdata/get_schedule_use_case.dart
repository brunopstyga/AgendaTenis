
import 'package:injectable/injectable.dart';
import '../../../../../core/util/result.dart';
import '../../repositories/AvailabilityRepository.dart';
@injectable
class GetScheduleUseCase {
  final AvailabilityRepository _repository;

  GetScheduleUseCase(this._repository);

  Future<Result<Map<String, List<Map<String, dynamic>>>>> call() async {
    return await _repository.getSchedule();
  }
}