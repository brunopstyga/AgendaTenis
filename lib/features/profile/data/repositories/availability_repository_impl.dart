import '../../../../core/database/app_database.dart';
import '../../../../core/database/dataconfigurationmenu/AvailabilityDao.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/AvailabilityRepository.dart';


@LazySingleton(as: AvailabilityRepository)
class AvailabilityRepositoryImpl implements AvailabilityRepository {
  final AvailabilityDao _dao;

  AvailabilityRepositoryImpl(this._dao);

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
  Future<Map<String, List<Map<String, dynamic>>>> getSchedule() async {
    final dbSlots = await _dao.getAllSlots();

    if (dbSlots.isEmpty) {
      return _defaultSchedule;
    }

    final Map<String, List<Map<String, dynamic>>> scheduleMap = {
      'Lunes': [], 'Martes': [], 'Miércoles': [], 'Jueves': [], 'Viernes': [], 'Sábado': [], 'Domingo': []
    };

    for (var slot in dbSlots) {
      if (scheduleMap.containsKey(slot.day)) {
        scheduleMap[slot.day]!.add({
          'time': slot.time,
          'price': slot.price,
        });
      }
    }

    return scheduleMap;
  }

  @override
  Future<void> saveSchedule(Map<String, List<Map<String, dynamic>>> newSchedule) async {
    await _dao.deleteAllSlots();

    for (var entry in newSchedule.entries) {
      final day = entry.key;
      for (var slot in entry.value) {
        await _dao.insertSlot(
          AvailabilitySlotsCompanion.insert(
            day: day,
            time: slot['time'],
            price: slot['price'],
          ),
        );
      }
    }
  }
}