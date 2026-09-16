import 'package:drift/drift.dart';

@DataClassName('LoginUser')
class LoginUsers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().unique()();
  TextColumn get password => text()();
  TextColumn get name => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}