import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/util/result.dart';
import '../../domain/usecases/addlessonusecase.dart';
import '../../domain/usecases/deletelessonusecase.dart';
import '../../domain/usecases/updatelessonusecase.dart';
import '../../domain/usecases/watchlessonsusecase.dart';
import 'lessons_state.dart';
import 'lessons_intent.dart';

@injectable
class LessonsBloc extends Bloc<LessonsIntent, LessonsState> {
  final WatchLessonsUseCase _watchLessonsUseCase;
  final AddLessonUseCase _addLessonUseCase;
  final DeleteLessonUseCase _deleteLessonUseCase;
  final UpdateLessonUseCase _updateLessonUseCase;

  LessonsBloc({
    required WatchLessonsUseCase watchLessonsUseCase,
    required AddLessonUseCase addLessonUseCase,
    required DeleteLessonUseCase deleteLessonUseCase,
    required UpdateLessonUseCase updateLessonUseCase,
  })  : _watchLessonsUseCase = watchLessonsUseCase,
        _addLessonUseCase = addLessonUseCase,
        _deleteLessonUseCase = deleteLessonUseCase,
        _updateLessonUseCase = updateLessonUseCase,
        super(const LessonsState()) {
    on<LoadLessons>(_onLoadLessons);
    on<AddLessonIntent>(_onAddLesson);
    on<UpdateLessonIntent>(_onUpdateLesson);
    on<DeleteLessonIntent>(_onDeleteLesson);
  }

  Future<void> _onLoadLessons(LoadLessons event, Emitter<LessonsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await emit.forEach(
        _watchLessonsUseCase(),
        onData: (slots) => state.copyWith(isLoading: false, slots: slots),
        onError: (error, _) => state.copyWith(isLoading: false, errorMessage: error.toString()),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddLesson(AddLessonIntent event, Emitter<LessonsState> emit) async {
    final existingSlotsForTime = state.slots.where((s) =>
    s.date == event.date && s.timeSlot == event.timeSlot
    ).toList();

    if (event.classType == 'Individual') {
      if (existingSlotsForTime.isNotEmpty) {
        emit(state.copyWith(
            errorMessage: "Todos los turnos estan asignados para este horario"
        ));
        return;
      }
    } else if (event.classType == 'Grupal') {
      final hasIndividual = existingSlotsForTime.any((s) => s.classType == 'Individual');
      if (hasIndividual) {
        emit(state.copyWith(
            errorMessage: 'Este horario ya está reservado por una clase individual.'
        ));
        return;
      }

      final groupCount = existingSlotsForTime.where((s) => s.classType == 'Grupal').length;
      if (groupCount >= 4) {
        emit(state.copyWith(
            errorMessage: 'Cupo lleno: La clase grupal ya alcanzó el límite máximo de 4 alumnos para este horario.'
        ));
        return;
      }
    }


    emit(state.copyWith(errorMessage: null));

    final result = await _addLessonUseCase(
      id: event.id,
      userId: event.userId,
      title: event.title,
      date: event.date,
      timeSlot: event.timeSlot,
      totalSpots: event.totalSpots,
      availableSpots: event.availableSpots,
      isBooked: event.isBooked,
      studentName: event.studentName,
      studentPhone: event.studentPhone,
      studentEmail: event.studentEmail,
      price: event.price,
      level: event.level,
      classType: event.classType,
    );

    switch (result) {
      case Success():
        emit(state.copyWith(errorMessage: null));
      case Failure(message: final errorMsg):
        emit(state.copyWith(errorMessage: errorMsg));
    }
  }

  Future<void> _onUpdateLesson(UpdateLessonIntent event, Emitter<LessonsState> emit) async {
    final result = await _updateLessonUseCase(
      id: event.id,
      userId: event.userId,
      title: event.title,
      date: event.date,
      timeSlot: event.timeSlot,
      totalSpots: event.totalSpots,
      availableSpots: event.availableSpots,
      isBooked: event.isBooked,
      studentName: event.studentName,
      studentPhone: event.studentPhone,
      studentEmail: event.studentEmail,
      price: event.price,
      level: event.level,
      classType: event.classType,
    );

    switch (result) {
      case Success():
        break;
      case Failure(message: final errorMsg):
        emit(state.copyWith(errorMessage: errorMsg));
    }
  }

  Future<void> _onDeleteLesson(DeleteLessonIntent event, Emitter<LessonsState> emit) async {
    final result = await _deleteLessonUseCase(event.id);

    switch (result) {
      case Success():
        break;
      case Failure(message: final errorMsg):
        emit(state.copyWith(errorMessage: errorMsg));
    }
  }
}