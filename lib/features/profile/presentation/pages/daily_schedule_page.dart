import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/lessons_state.dart';
import '../util/input_validators.dart';
import '../widgets/daily_metric_card.dart';
import '../widgets/daily_slot_item.dart';


class DailySchedulePage extends StatelessWidget {
  const DailySchedulePage({super.key});

  String _formatCurrency(double amount) {
    final stringValue = amount.toStringAsFixed(0);
    final regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return stringValue.replaceAllMapped(regExp, (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dailyScheduleTitle),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<LessonsBloc, LessonsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text('${AppStrings.errorLabel}: ${state.errorMessage}'));
          }


          final targetDay = InputValidators.getCurrentDayName(null);

          // Filtramos los slots con el día correspondiente
          final slots = state.slots.where((slot) {
            return slot.date.trim().toLowerCase() == targetDay.toLowerCase();
          }).toList();

          double totalRevenue = 0.0;
          for (var slot in slots) {
            final hasStudent = slot.studentName != null && slot.studentName!.trim().isNotEmpty;
            if (hasStudent) {
              totalRevenue += (slot.price ?? 0.0);
            }
          }

          final totalCount = slots.length;
          final occupiedCount = slots.where((s) => s.studentName != null && s.studentName!.isNotEmpty).length;
          final freeCount = slots.where((s) => s.studentName == null || s.studentName!.isEmpty).length;

          return Column(
            children: [
              // Sección de Métricas desacoplada
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                color: Colors.green.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DailyMetricCard(title: '$totalCount', value: '$totalCount', icon: Icons.schedule),
                    DailyMetricCard(title: '$occupiedCount', value: '$occupiedCount', icon: Icons.person),
                    DailyMetricCard(title: '$freeCount', value: '$freeCount', icon: Icons.event_available),
                    DailyMetricCard(title: AppStrings.revenueMetric,
                        value: '\$${_formatCurrency(totalRevenue)}',
                        icon: Icons.attach_money),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1),

              // Lista de turnos desacoplada
              Expanded(
                child: slots.isEmpty
                    ? Center(child: Text('${AppStrings.noRecordsForDay} ($targetDay)'))
                    : ListView.separated(
                  itemCount: slots.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    return DailySlotItem(slot: slots[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}