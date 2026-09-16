import 'package:injectable/injectable.dart';

import '../../../../../core/database/app_database.dart';

@injectable
class StudentFlowManager {
  final AppDatabase _database;

  StudentFlowManager(this._database);

  Future<bool> hasAssignedLesson(int userId) async {
    try {
      // Consulta directa a la tabla usando la API nativa de Drift
      final userLessons = await (_database.select(_database.lessonSlots)
        ..where((tbl) => tbl.userId.equals(userId)))
          .get();

      return userLessons.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}