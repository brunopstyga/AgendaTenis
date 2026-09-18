import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/util/result.dart';
import '../../domain/repositories/AvailabilityRepository.dart';

@LazySingleton(as: AvailabilityRepository)
class AvailabilityRepositoryImpl implements AvailabilityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'config';
  final String _docId = 'availability_schedule'; // Un documento único para guardar la configuración

  // Horarios hardcodeados por defecto (fallback)
  final Map<String, List<Map<String, dynamic>>> _defaultSchedule = {
    'Lunes': [
      {'time': '09:00 AM', 'price': 15000.0},
      {'time': '11:00 AM', 'price': 15000.0},
      {'time': '05:00 PM', 'price': 18000.0},
    ],
    'Martes': [
      {'time': '09:00 AM', 'price': 15000.0},
      {'time': '03:00 PM', 'price': 15000.0},
    ],
    'Miércoles': [
      {'time': '09:00 AM', 'price': 15000.0},
      {'time': '11:00 AM', 'price': 15000.0},
      {'time': '05:00 PM', 'price': 15000.0},
    ],
    'Jueves': [
      {'time': '09:00 AM', 'price': 15000.0},
      {'time': '03:00 PM', 'price': 15000.0},
    ],
    'Viernes': [
      {'time': '09:00 AM', 'price': 15000.0},
      {'time': '11:00 AM', 'price': 15000.0},
    ],
    'Sábado': [
      {'time': '10:00 AM', 'price': 20000.0},
    ],
    'Domingo': [],
  };

  @override
  Future<Result<Map<String, List<Map<String, dynamic>>>>> getSchedule() async {
    try {
      final docSnapshot = await _firestore.collection(_collection).doc(_docId).get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return Success(_defaultSchedule);
      }

      final data = docSnapshot.data()!['schedule'] as Map<String, dynamic>?;
      if (data == null || data.isEmpty) {
        return Success(_defaultSchedule);
      }

      Map<String, List<Map<String, dynamic>>> scheduleMap = {};
      data.forEach((day, slots) {
        scheduleMap[day] = (slots as List).map((slot) {
          return {
            'time': slot['time'].toString(),
            'price': (slot['price'] as num).toDouble(),
          };
        }).toList();
      });

      return Success(scheduleMap);
    } catch (e) {
      return Failure('Error al obtener la disponibilidad: $e', e is Exception ? e : null);
    }
  }

  @override
  Future<Result<void>> saveSchedule(Map<String, List<Map<String, dynamic>>> newSchedule) async {
    try {
      await _firestore.collection(_collection).doc(_docId).set({
        'schedule': newSchedule,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Success(null);
    } catch (e) {
      return Failure('Error al guardar la disponibilidad: $e');
    }
  }
}