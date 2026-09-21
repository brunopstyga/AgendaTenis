import 'package:flutter/foundation.dart';

@immutable
abstract class AvailabilityState {}

class AvailabilityInitial extends AvailabilityState {}

class AvailabilityLoading extends AvailabilityState {}

class AvailabilityLoaded extends AvailabilityState {
  final Map<String, Map<String, dynamic>> schedule;

  AvailabilityLoaded(this.schedule);
}

class AvailabilitySaving extends AvailabilityState {
  final Map<String, Map<String, dynamic>> schedule;

  AvailabilitySaving(this.schedule);
}

class AvailabilitySavedSuccess extends AvailabilityState {}

class AvailabilityError extends AvailabilityState {
  final String message;

  AvailabilityError(this.message);
}