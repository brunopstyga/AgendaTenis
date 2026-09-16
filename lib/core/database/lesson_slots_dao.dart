import 'package:drift/drift.dart';
import 'app_database.dart';
import 'lesson_slots_table.dart';

part 'lesson_slots_dao.g.dart';

@DriftAccessor(tables: [LessonSlots])
class LessonSlotsDao extends DatabaseAccessor<AppDatabase> with _$LessonSlotsDaoMixin {
  LessonSlotsDao(super.db);

  // Obtener todos los turnos (ideal para mostrar en una lista)
  Stream<List<LessonSlot>> watchAllSlots() => select(lessonSlots).watch();

  // Obtener todos los turnos como una lista única (sin stream)
  Future<List<LessonSlot>> getAllSlots() => select(lessonSlots).get();

  // Insertar un nuevo turno/bloque
  Future<int> insertSlot(LessonSlotsCompanion slot) => into(lessonSlots).insert(slot);

  // Actualizar un turno existente
  Future<bool> updateSlot(LessonSlot slot) => update(lessonSlots).replace(slot);

  // Eliminar un turno por su ID
  Future<int> deleteSlot(String id) => (delete(lessonSlots)..where((tbl) => tbl.id.equals(id))).go();}