import 'package:drift/drift.dart';

class AvailabilitySlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get day => text()(); // Ej: 'Lunes', 'Martes'
  TextColumn get time => text()(); // Ej: '09:00 AM'
  RealColumn get price => real()(); // Ej: 15000.0
}