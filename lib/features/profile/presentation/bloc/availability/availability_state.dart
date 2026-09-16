import 'package:flutter/foundation.dart';

@immutable
abstract class AvailabilityState {}

class AvailabilityInitial extends AvailabilityState {}

class AvailabilityLoading extends AvailabilityState {}

class AvailabilityLoaded extends AvailabilityState {
  final Map<String, List<Map<String, dynamic>>> schedule;

  AvailabilityLoaded(this.schedule);
}

class AvailabilitySaving extends AvailabilityLoaded {
  AvailabilitySaving(super.schedule);
}

class AvailabilitySavedSuccess extends AvailabilityState {}

class AvailabilityError extends AvailabilityState {
  final String message;

  AvailabilityError(this.message);
}