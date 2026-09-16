abstract class LessonsIntent {}

class LoadLessons extends LessonsIntent {}

class AddLessonIntent extends LessonsIntent {
  final String id;
  final int? userId;
  final String title;
  final String date;
  final String timeSlot;
  final int totalSpots;
  final int availableSpots;
  final bool isBooked;
  final String? studentName;
  final String? studentPhone;
  final String? studentEmail;
  final double price;

  AddLessonIntent({
    required this.id,
    this.userId,
    required this.title,
    required this.date,
    required this.timeSlot,
    required this.totalSpots,
    required this.availableSpots,
    required this.isBooked,
    this.studentName,
    this.studentPhone,
    this.studentEmail,
    required this.price,
  });
}

class UpdateLessonIntent extends LessonsIntent {
  final String id;
  final int? userId;
  final String title;
  final String date;
  final String timeSlot;
  final int totalSpots;
  final int availableSpots;
  final bool isBooked;
  final String? studentName;
  final String? studentPhone;
  final String? studentEmail;
  final double price;


  UpdateLessonIntent({
    required this.id,
    this.userId,
    required this.title,
    required this.date,
    required this.timeSlot,
    required this.totalSpots,
    required this.availableSpots,
    required this.isBooked,
    this.studentName,
    this.studentPhone,
    this.studentEmail,
    required this.price,
  });
}

class DeleteLessonIntent extends LessonsIntent {
  final String id;
  DeleteLessonIntent(this.id);
}