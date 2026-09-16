import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';


import '../../../domain/usecases/configurationdata/get_schedule_use_case.dart';
import '../../../domain/usecases/configurationdata/save_schedule_use_case.dart';
import 'AvailabilityIntent.dart';
import 'availability_state.dart';

@injectable
class AvailabilityBloc extends Bloc<AvailabilityIntent, AvailabilityState> {
  final GetScheduleUseCase _getScheduleUseCase;
  final SaveScheduleUseCase _saveScheduleUseCase;

  AvailabilityBloc(
      this._getScheduleUseCase,
      this._saveScheduleUseCase,
      ) : super(AvailabilityInitial()) {
    on<LoadAvailabilityIntent>(_onLoadAvailability);
    on<SaveAvailabilityIntent>(_onSaveAvailability);
  }

  Future<void> _onLoadAvailability(
      LoadAvailabilityIntent event,
      Emitter<AvailabilityState> emit,
      ) async {
    emit(AvailabilityLoading());
    try {
      final schedule = await _getScheduleUseCase.call();
      emit(AvailabilityLoaded(schedule));
    } catch (e) {
      emit(AvailabilityError(e.toString()));
    }
  }

  Future<void> _onSaveAvailability(
      SaveAvailabilityIntent event,
      Emitter<AvailabilityState> emit,
      ) async {
    if (state is AvailabilityLoaded) {
      emit(AvailabilitySaving((state as AvailabilityLoaded).schedule));
    } else {
      emit(AvailabilityLoading());
    }

    try {
      await _saveScheduleUseCase.call(event.schedule);
      emit(AvailabilitySavedSuccess());
      // Recargamos el estado loaded con los datos nuevos
      final updatedSchedule = await _getScheduleUseCase.call();
      emit(AvailabilityLoaded(updatedSchedule));
    } catch (e) {
      emit(AvailabilityError(e.toString()));
    }
  }
}