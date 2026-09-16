import 'package:flutter/foundation.dart';

@immutable
abstract class AvailabilityIntent {}

class LoadAvailabilityIntent extends AvailabilityIntent {}

class SaveAvailabilityIntent extends AvailabilityIntent {
  final Map<String, List<Map<String, dynamic>>> schedule;

  SaveAvailabilityIntent(this.schedule);
}