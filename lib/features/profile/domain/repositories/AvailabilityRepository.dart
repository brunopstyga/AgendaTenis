abstract class AvailabilityRepository {
  Future<Map<String, List<Map<String, dynamic>>>> getSchedule();
  Future<void> saveSchedule(Map<String, List<Map<String, dynamic>>> newSchedule);
}