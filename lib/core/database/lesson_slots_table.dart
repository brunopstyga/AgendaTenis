import 'package:drift/drift.dart';
import 'login_user/login_user.dart';

class LessonSlots extends Table {
  TextColumn get id => text()();
  IntColumn get userId => integer().nullable().references(LoginUsers, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get date => text()();
  TextColumn get timeSlot => text()();
  IntColumn get totalSpots5 => integer()();
  IntColumn get availableSpots => integer()();
  BoolColumn get isBooked => boolean().withDefault(const Constant(false))();
  TextColumn get studentName => text().nullable()();
  TextColumn get studentPhone => text().nullable()();
  TextColumn get studentEmail => text().nullable()();
  RealColumn get price => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}