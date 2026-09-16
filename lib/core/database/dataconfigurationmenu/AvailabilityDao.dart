import 'package:drift/drift.dart';

import '../app_database.dart';
import 'AvailabilitySlots.dart';
part 'AvailabilityDao.g.dart';

@DriftAccessor(tables: [AvailabilitySlots])
class AvailabilityDao extends DatabaseAccessor<AppDatabase> with _$AvailabilityDaoMixin {
  AvailabilityDao(super.db);

  // ¡AQUÍ ESTÁ EL CAMBIO! Debe ser AvailabilitySlot (sin la "s" al final)
  Future<List<AvailabilitySlot>> getAllSlots() => select(availabilitySlots).get();

  // Insertar un horario
  Future<int> insertSlot(AvailabilitySlotsCompanion slot) => into(availabilitySlots).insert(slot);

  // Limpiar toda la tabla
  Future<int> deleteAllSlots() => delete(availabilitySlots).go();
}