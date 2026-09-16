import '../../../../core/database/app_database.dart';

class LessonsState {
  final bool isLoading;
  final List<LessonSlot> slots;
  final String? errorMessage;

  const LessonsState({
    this.isLoading = false,
    this.slots = const [],
    this.errorMessage,
  });

  LessonsState copyWith({
    bool? isLoading,
    List<LessonSlot>? slots,
    String? errorMessage,
  }) {
    return LessonsState(
      isLoading: isLoading ?? this.isLoading,
      slots: slots ?? this.slots,
      errorMessage: errorMessage,
    );
  }
}