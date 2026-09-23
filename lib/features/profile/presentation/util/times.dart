class Times {
  // Método 1: Para comparar en la grilla (devuelve la hora en formato 24hs)
  static int convert12HourTo24(String timeSlotStr) {
    try {
      final startTimePart = timeSlotStr.split('-')[0].trim();

      if (!startTimePart.toUpperCase().contains('AM') && !startTimePart.toUpperCase().contains('PM')) {
        return int.tryParse(startTimePart.split(':')[0]) ?? -1;
      }

      final parts = startTimePart.split(' ');
      if (parts.length < 2) return -1;

      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      final modifier = parts[1].toUpperCase();

      if (modifier == 'PM' && hour < 12) hour += 12;
      if (modifier == 'AM' && hour == 12) hour = 0;
      return hour;
    } catch (_) {
      return -1;
    }
  }

  // Método 2: Para calcular el horario de fin (devuelve un String formateado)
  static String calculateEndTime(String startTimeSlot) {
    try {
      final cleaned = startTimeSlot.trim().toUpperCase();
      final isPm = cleaned.contains('PM');
      final isAm = cleaned.contains('AM');

      final parts = cleaned.replaceAll(RegExp(r'[^0-9:]'), '').split(':');
      if (parts.isEmpty) return '';

      int hour = int.parse(parts[0]);
      int minute = parts.length > 1 ? int.parse(parts[1]) : 0;

      if (isPm && hour < 12) hour += 12;
      if (isAm && hour == 12) hour = 0;

      hour = (hour + 1) % 24;

      final period = hour >= 12 ? 'PM' : 'AM';
      int displayHour = hour % 12;
      if (displayHour == 0) displayHour = 12;

      final formattedMinute = minute.toString().padLeft(2, '0');
      return '$displayHour:$formattedMinute $period';
    } catch (_) {
      return '';
    }
  }
}