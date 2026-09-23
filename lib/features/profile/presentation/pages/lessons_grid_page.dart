import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/lessons_state.dart';
import '../components/app_snack_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/grid_cell_widget.dart';

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
                          DataCell(
                            GridCellWidget(
                              slots: state.slots,
                              dayName: dayNames[i],
                              timeRange: timeRange,
                            ),
                          ),
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
}