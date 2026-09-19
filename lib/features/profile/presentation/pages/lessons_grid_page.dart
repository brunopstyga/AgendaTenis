import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/lessons_state.dart';
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

    final List<String> timeSlots = List.generate(15, (index) {
      final hour = 8 + index;
      return '${hour.toString().padLeft(2, '0')}:00';
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
      // Usamos BlocConsumer para escuchar errores y mostrar el SnackBar igual que en la lista
      body: BlocConsumer<LessonsBloc, LessonsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
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
                  rows: timeSlots.map((time) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        for (int i = 0; i < weekDates.length; i++)
                          DataCell(_buildGridCell(state.slots, dayNames[i], time)),
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

  Widget _buildGridCell(List slots, String dayName, String timeHour) {
    final matchingSlots = slots.where((slot) {
      final matchesDay = slot.date == dayName;
      final matchesTime = slot.timeSlot.startsWith(timeHour.substring(0, 2));
      return matchesDay && matchesTime;
    }).toList();

    int totalStudents = matchingSlots.length;

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
        '$totalStudents',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}