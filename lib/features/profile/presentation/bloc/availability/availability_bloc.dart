import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/util/result.dart';
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

    final result = await _getScheduleUseCase.call();

    switch (result) {
      case Success(data: final schedule):
        emit(AvailabilityLoaded(schedule));

      case Failure(message: final errorMsg):
        emit(AvailabilityError(errorMsg));
    }
  }

  Future<void> _onSaveAvailability(
      SaveAvailabilityIntent event,
      Emitter<AvailabilityState> emit,
      ) async {
    emit(AvailabilitySaving(event.schedule));

    final saveResult = await _saveAvailability(event.schedule);

    switch (saveResult) {
      case Success():
        emit(AvailabilitySavedSuccess());

        final getResult = await _getScheduleUseCase.call();

        switch (getResult) {
          case Success(data: final updatedSchedule):
            emit(AvailabilityLoaded(updatedSchedule));

          case Failure(message: final errorMsg):
            emit(AvailabilityError(errorMsg));
        }

      case Failure(message: final errorMsg):
        emit(AvailabilityError(errorMsg));
    }
  }

  Future<Result<dynamic>> _saveAvailability(
      Map<String, Map<String, dynamic>> schedule,
      ) async {
    return await _saveScheduleUseCase.call(schedule);
  }
}