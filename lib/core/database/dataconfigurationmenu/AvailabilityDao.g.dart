// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AvailabilityDao.dart';

// ignore_for_file: type=lint
mixin _$AvailabilityDaoMixin on DatabaseAccessor<AppDatabase> {
  $AvailabilitySlotsTable get availabilitySlots =>
      attachedDatabase.availabilitySlots;
  AvailabilityDaoManager get managers => AvailabilityDaoManager(this);
}

class AvailabilityDaoManager {
  final _$AvailabilityDaoMixin _db;
  AvailabilityDaoManager(this._db);
  $$AvailabilitySlotsTableTableManager get availabilitySlots =>
      $$AvailabilitySlotsTableTableManager(
        _db.attachedDatabase,
        _db.availabilitySlots,
      );
}
