import 'package:flutter/material.dart';

class DaySelectorWidget extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final ScrollController scrollController;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onScrollLeft;
  final VoidCallback onScrollRight;
  final Map<DateTime, GlobalKey> dayKeys;

  const DaySelectorWidget({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.scrollController,
    required this.onDaySelected,
    required this.onScrollLeft,
    required this.onScrollRight,
    required this.dayKeys,
  });

  // Función auxiliar para obtener el nombre corto del día en español
  String _getDayNameShort(int weekday) {
    const daysNames = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return daysNames[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onScrollLeft,
          ),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final date = dates[index];
                  // Comprobamos si es exactamente el mismo día, mes y año
                  final isSelected = DateUtils.isSameDay(date, selectedDate);
                  final dayName = _getDayNameShort(date.weekday);
                  final dayNumber = date.day;

                  return Padding(
                    key: dayKeys[date],
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Center(
                      child: ChoiceChip(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        checkmarkColor: Colors.black,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dayName,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected ? Colors.black : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.black.withOpacity(0.1) : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$dayNumber',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.black : Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (_) => onDaySelected(date),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onScrollRight,
          ),
        ],
      ),
    );
  }
}