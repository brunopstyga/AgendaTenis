import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/util/result.dart';
import '../../domain/repositories/AvailabilityRepository.dart';

@LazySingleton(as: AvailabilityRepository)
class AvailabilityRepositoryImpl implements AvailabilityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'config';
  final String _docId = 'availability_schedule'; // Un documento único para la configuración

  // Estructura por defecto utilizando el nuevo modelo conceptual de rangos y precios
  final Map<String, Map<String, dynamic>> _defaultSchedule = {
    'Lunes': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': {
        'Grupal': 15000.0,
        'Individual': 20000.0,
        'Individual Exclusivo': 25000.0,
      },
    },
    'Martes': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': {
        'Grupal': 15000.0,
        'Individual': 20000.0,
        'Individual Exclusivo': 25000.0,
      },
    },
    'Miércoles': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': {
        'Grupal': 15000.0,
        'Individual': 20000.0,
        'Individual Exclusivo': 25000.0,
      },
    },
    'Jueves': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': {
        'Grupal': 15000.0,
        'Individual': 20000.0,
        'Individual Exclusivo': 25000.0,
      },
    },
    'Viernes': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': {
        'Grupal': 15000.0,
        'Individual': 20000.0,
        'Individual Exclusivo': 25000.0,
      },
    },
    'Sábado': {
      'startTime': '09:00',
      'endTime': '14:00',
      'prices': {
        'Grupal': 20000.0,
        'Individual': 25000.0,
        'Individual Exclusivo': 30000.0,
      },
    },
    'Domingo': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': {
        'Grupal': 0.0,
        'Individual': 0.0,
        'Individual Exclusivo': 0.0,
      },
    },
  };

  @override
  Future<Result<Map<String, Map<String, dynamic>>>> getSchedule() async {
    try {
      final docSnapshot = await _firestore.collection(_collection).doc(_docId).get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return Success(_defaultSchedule);
      }

      final data = docSnapshot.data()!['schedule'] as Map<String, dynamic>?;
      if (data == null || data.isEmpty) {
        return Success(_defaultSchedule);
      }

      // Mapeo seguro al nuevo formato de Mapa de Mapas
      Map<String, Map<String, dynamic>> scheduleMap = {};
      data.forEach((day, dayData) {
        if (dayData is Map) {
          final startTime = dayData['startTime']?.toString() ?? '08:00';
          final endTime = dayData['endTime']?.toString() ?? '21:00';

          final rawPrices = dayData['prices'] as Map<String, dynamic>? ?? {};
          Map<String, double> parsedPrices = {};
          rawPrices.forEach((classType, priceVal) {
            parsedPrices[classType] = (priceVal as num?)?.toDouble() ?? 0.0;
          });

          scheduleMap[day] = {
            'startTime': startTime,
            'endTime': endTime,
            'prices': parsedPrices,
          };
        }
      });

      return Success(scheduleMap);
    } catch (e) {
      return Failure('${AppStrings.errorGetRepositoyImpl}: $e', e is Exception ? e : null);
    }
  }

  @override
  Future<Result<void>> saveSchedule(Map<String, Map<String, dynamic>> newSchedule) async {
    try {
      await _firestore.collection(_collection).doc(_docId).set({
        'schedule': newSchedule,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Success(null);
    } catch (e) {
      return Failure('${AppStrings.errorSaveRepositoyImpl}: $e');
    }
  }
}