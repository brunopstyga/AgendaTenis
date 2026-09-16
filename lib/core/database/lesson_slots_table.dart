import 'package:drift/drift.dart';

@DataClassName('LessonSlot')
class LessonSlots extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get date => text()();
  TextColumn get timeSlot => text()();
  IntColumn get totalSpots => integer()();
  IntColumn get availableSpots => integer()();
  BoolColumn get isBooked => boolean().withDefault(const Constant(false))();

  // Nuevos campos para soportar tanto la inscripción manual del profe como el login de Google/Apple
  TextColumn get studentName => text().nullable()();
  TextColumn get studentPhone => text().nullable()();
  TextColumn get studentEmail => text().nullable()();

  RealColumn get price => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}