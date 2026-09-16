import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'lesson_slots_dao.dart';
import 'lesson_slots_table.dart';
import 'login_user/login_dao.dart';
import 'login_user/login_user.dart';
import 'dataconfigurationmenu/AvailabilitySlots.dart';
import 'dataconfigurationmenu/AvailabilityDao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    LessonSlots,
    AvailabilitySlots,
    LoginUsers,
  ],
  daos: [
    LessonSlotsDao,
    AvailabilityDao,
    LoginDao,
  ],
)
@DriftDatabase(tables: [LessonSlots])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tennis_scheduler.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}