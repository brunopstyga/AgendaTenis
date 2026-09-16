// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_slots_dao.dart';

// ignore_for_file: type=lint
mixin _$LessonSlotsDaoMixin on DatabaseAccessor<AppDatabase> {
  $LoginUsersTable get loginUsers => attachedDatabase.loginUsers;
  $LessonSlotsTable get lessonSlots => attachedDatabase.lessonSlots;
  LessonSlotsDaoManager get managers => LessonSlotsDaoManager(this);
}

class LessonSlotsDaoManager {
  final _$LessonSlotsDaoMixin _db;
  LessonSlotsDaoManager(this._db);
  $$LoginUsersTableTableManager get loginUsers =>
      $$LoginUsersTableTableManager(_db.attachedDatabase, _db.loginUsers);
  $$LessonSlotsTableTableManager get lessonSlots =>
      $$LessonSlotsTableTableManager(_db.attachedDatabase, _db.lessonSlots);
}
