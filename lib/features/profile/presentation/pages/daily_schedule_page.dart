import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/lessons_state.dart';
import 'dart:developer' as developer;

class DailySchedulePage extends StatelessWidget {
  const DailySchedulePage({super.key});

  String _calculateEndTime(String startTimeSlot) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planilla del Día'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<LessonsBloc, LessonsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          final slots = state.slots;

          double totalRevenue = 0.0;
          for (var slot in slots) {
            final hasStudent = slot.studentName != null && slot.studentName!.trim().isNotEmpty;
            if (hasStudent) {
              developer.log('Slot: $slot');
              totalRevenue += (slot.price ?? 0.0);
            }
          }

          return Column(
            children: [
              // 1. Métricas resumidas con Recaudación incluida
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                color: Colors.green.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricCard('Total', '${slots.length}', Icons.schedule),
                    _buildMetricCard('Ocupados', '${slots.where((s) => s.studentName != null && s.studentName!.isNotEmpty).length}', Icons.person),
                    _buildMetricCard('Libres', '${slots.where((s) => s.studentName == null || s.studentName!.isEmpty).length}', Icons.event_available),
                    _buildMetricCard('Recaudado', '\$${totalRevenue.toStringAsFixed(0)}', Icons.attach_money),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1),

              // 2. Lista resumida y limpia sin tarjetas
              Expanded(
                child: slots.isEmpty
                    ? const Center(child: Text('No hay registros para este día'))
                    : ListView.separated(
                  itemCount: slots.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    final hasStudent = slot.studentName != null && slot.studentName!.trim().isNotEmpty;
                    final studentText = hasStudent ? slot.studentName! : 'Disponible';
                    final phoneText = (slot.studentPhone != null && slot.studentPhone!.isNotEmpty) ? ' • ${slot.studentPhone}' : '';

                    final endTime = _calculateEndTime(slot.timeSlot);
                    final timeRangeText = endTime.isNotEmpty
                        ? '${slot.timeSlot} a $endTime'
                        : slot.timeSlot;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: Text(
                              timeRangeText,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  slot.title,
                                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$studentText$phoneText',
                                  style: TextStyle(
                                    fontWeight: hasStudent ? FontWeight.w600 : FontWeight.normal,
                                    fontSize: 14,
                                    color: hasStudent ? Colors.black87 : Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasStudent ? Colors.green : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade700, size: 18),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}