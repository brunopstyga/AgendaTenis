import 'availability_state.dart';

class AvailabilityLoaded extends AvailabilityState {
  final Map<String, List<Map<String, dynamic>>> schedule;

  AvailabilityLoaded(this.schedule);
}