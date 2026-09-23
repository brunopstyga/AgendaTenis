import 'package:flutter/material.dart';

class DailySlotItem extends StatelessWidget {
  final dynamic slot;

  const DailySlotItem({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    final hasStudent = slot.studentName != null && slot.studentName!.trim().isNotEmpty;
    final studentText = hasStudent ? slot.studentName! : 'Disponible';
    final phoneText = (slot.studentPhone != null && slot.studentPhone!.isNotEmpty) ? ' • ${slot.studentPhone}' : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              slot.timeSlot,
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
        ],
      ),
    );
  }
}