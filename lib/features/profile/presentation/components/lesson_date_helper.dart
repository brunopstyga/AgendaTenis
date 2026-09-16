class LessonDateHelper {
  static const Map<String, int> daysMap = {
    'Lunes': 1, 'Martes': 2, 'Miércoles': 3, 'Jueves': 4,
    'Viernes': 5, 'Sábado': 6, 'Domingo': 7
  };

  static String getCurrentDayName() {
    final currentWeekday = DateTime.now().weekday;
    return daysMap.entries
        .firstWhere((entry) => entry.value == currentWeekday, orElse: () => const MapEntry('Lunes', 1))
        .key;
  }

  static bool isPastDateTime(String dayString, String timeSlotString) {
    final now = DateTime.now();
    final currentDayOfWeek = now.weekday;
    final targetDayOfWeek = daysMap[dayString] ?? currentDayOfWeek;

    if (targetDayOfWeek < currentDayOfWeek) return true;

    if (targetDayOfWeek == currentDayOfWeek) {
      try {
        final isPm = timeSlotString.contains('PM');
        final cleanTime = timeSlotString.replaceAll(RegExp(r'[^0-9:]'), '');
        final parts = cleanTime.split(':');
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);

        if (isPm && hour != 12) hour += 12;
        if (!isPm && hour == 12) hour = 0;

        final slotTimeToday = DateTime(now.year, now.month, now.day, hour, minute);
        if (slotTimeToday.isBefore(now)) return true;
      } catch (_) {}
    }
    return false;
  }
}