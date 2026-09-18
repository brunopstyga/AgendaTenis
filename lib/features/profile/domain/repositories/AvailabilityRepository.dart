import '../../../../core/util/result.dart';

abstract class AvailabilityRepository {
  Future<Result<Map<String, List<Map<String, dynamic>>>>> getSchedule();

  Future<Result<void>> saveSchedule(Map<String, List<Map<String, dynamic>>> newSchedule);
}