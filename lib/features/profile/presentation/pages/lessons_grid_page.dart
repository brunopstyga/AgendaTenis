import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/lessons_state.dart';
import '../components/app_snack_bar.dart';
import '../widgets/app_drawer.dart';

class LessonsGridPage extends StatelessWidget {
  final bool isTeacher;
  final VoidCallback? onLoginLocal;
  final VoidCallback? onShowDailySchedule;
  final VoidCallback? onShowWeeklySchedule;
  final VoidCallback? onConfigureAvailability;
  final VoidCallback? onLogout;

  const LessonsGridPage({
    super.key,
    required this.isTeacher,
    this.onLoginLocal,
    this.onShowDailySchedule,
    this.onShowWeeklySchedule,
    this.onConfigureAvailability,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final List<DateTime> weekDates = List.generate(7, (index) {
      return now.add(Duration(days: index - now.weekday + 1));
    });

    // Generamos los rangos horarios completos para la columna izquierda (ej. "08:00 - 09:00")
    final List<String> timeSlots = List.generate(15, (index) {
      final startHour = 8 + index;
      final endHour = startHour + 1;
      return '${startHour.toString().padLeft(2, '0')}:00 - ${endHour.toString().padLeft(2, '0')}:00';
    });

    const dayNames = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grilla Semanal Completa'),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: AppDrawer(
        isTeacher: isTeacher,
        isGridPage: true,
        onBackToList: () => Navigator.pop(context),
        onLoginLocal: onLoginLocal,
        onShowDailySchedule: onShowDailySchedule,
        onShowWeeklySchedule: onShowWeeklySchedule,
        onConfigureAvailability: onConfigureAvailability,
        onShowGridPage: () {},
        onLogout: onLogout,
      ),
      body: BlocConsumer<LessonsBloc, LessonsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppSnackBar.show(context, state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DataTable(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columns: [
                    const DataColumn(
                      label: Text('Horario', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    for (int i = 0; i < weekDates.length; i++)
                      DataColumn(
                        label: Text(
                          '${dayNames[i]} ${weekDates[i].day}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                  rows: timeSlots.map((timeRange) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(timeRange, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        for (int i = 0; i < weekDates.length; i++)
                          DataCell(_buildGridCell(state.slots, dayNames[i], timeRange)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridCell(List slots, String dayName, String timeRange) {
    final matchingSlots = slots.where((slot) {
      // 1. Verificamos que el día coincida (ej: "Lunes" == "Lunes")
      final matchesDay = slot.date.trim().toLowerCase() == dayName.trim().toLowerCase();

      // 2. Convertimos la hora de inicio del slot a entero 24hs
      final slotHour24 = _convert12HourTo24(slot.timeSlot);

      // Extraemos la hora de inicio de la fila de la grilla
      final gridHour24 = int.tryParse(timeRange.split(':')[0]) ?? 0;

      final matchesTime = slotHour24 == gridHour24;

      return matchesDay && matchesTime;
    }).toList();

    // Sumamos los alumnos según el tipo de clase
    int totalStudents = 0;
    for (var slot in matchingSlots) {
      if (slot.classType != null && slot.classType.toLowerCase() == 'grupal') {
        totalStudents += 4; // Una clase grupal ocupa/representa 4 cupos completos
      } else {
        totalStudents += 1; // Una clase individual ocupa 1 cupo
      }
    }

    // Si hay 4 o más alumnos, se pone en rojo (cupo lleno)
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
  // Función auxiliar para transformar "09:00 AM", "09:00" o "10:00 AM - 11:00 AM" a formato entero 24hs
  int _convert12HourTo24(String timeSlotStr) {
    try {
      final startTimePart = timeSlotStr.split('-')[0].trim(); // Toma la hora de inicio

      // Si viene directo en formato "08:00" sin AM/PM
      if (!startTimePart.toUpperCase().contains('AM') && !startTimePart.toUpperCase().contains('PM')) {
        return int.tryParse(startTimePart.split(':')[0]) ?? -1;
      }

      final parts = startTimePart.split(' ');
      if (parts.length < 2) return -1;

      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      final modifier = parts[1].toUpperCase();

      if (modifier == 'PM' && hour < 12) {
        hour += 12;
      }
      if (modifier == 'AM' && hour == 12) {
        hour = 0;
      }
      return hour;
    } catch (_) {
      return -1;
    }
  }
}