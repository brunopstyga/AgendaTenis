

import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilitySlots{
  final String id;
  final String day;
  final String time;
  final double price;

  AvailabilitySlots({
    required this.id,
    required this.day,
    required this.time,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'time': time,
    'price': price,
  };

  factory AvailabilitySlots.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AvailabilitySlots(
      id: doc.id,
      day: data['day'] ?? '',
      time: data['time'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}