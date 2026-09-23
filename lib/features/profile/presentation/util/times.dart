class Times {
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