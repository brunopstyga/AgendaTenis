import 'package:flutter/foundation.dart';

@immutable
abstract class AvailabilityIntent {}

class LoadAvailabilityIntent extends AvailabilityIntent {}

class SaveAvailabilityIntent extends AvailabilityIntent {
  // Cambiado de List a Map para soportar el nuevo modelo conceptual
  final Map<String, Map<String, dynamic>> schedule;

  SaveAvailabilityIntent(this.schedule);
}