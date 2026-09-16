// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_slots_dao.dart';

// ignore_for_file: type=lint
mixin _$LessonSlotsDaoMixin on DatabaseAccessor<AppDatabase> {
  $LessonSlotsTable get lessonSlots => attachedDatabase.lessonSlots;
  LessonSlotsDaoManager get managers => LessonSlotsDaoManager(this);
}

class LessonSlotsDaoManager {
  final _$LessonSlotsDaoMixin _db;
  LessonSlotsDaoManager(this._db);
  $$LessonSlotsTableTableManager get lessonSlots =>
      $$LessonSlotsTableTableManager(_db.attachedDatabase, _db.lessonSlots);
}
