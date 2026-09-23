import 'package:flutter/material.dart';

import '../util/times.dart';


class GridCellWidget extends StatelessWidget {
  final List slots;
  final String dayName;
  final String timeRange;

  const GridCellWidget({
    super.key,
    required this.slots,
    required this.dayName,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    final matchingSlots = slots.where((slot) {
      final matchesDay = slot.date.trim().toLowerCase() == dayName.trim().toLowerCase();
      final slotHour24 = Times.convert12HourTo24(slot.timeSlot);
      final gridHour24 = int.tryParse(timeRange.split(':')[0]) ?? 0;

      return matchesDay && slotHour24 == gridHour24;
    }).toList();

    // Regla de negocio: "Grupal" = 4 alumnos, otros = 1 alumno
    int totalStudents = 0;
    for (var slot in matchingSlots) {
      if (slot.classType != null && slot.classType.toLowerCase() == 'grupal') {
        totalStudents += 4;
      } else {
        totalStudents += 1;
      }
    }

    bool isFull = totalStudents >= 4;
    Color cellColor = isFull ? Colors.red.shade400 : Colors.green.shade400;

    return Container(
      width: 90,
      height: 50,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        totalStudents > 0 ? '$totalStudents' : '0',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}