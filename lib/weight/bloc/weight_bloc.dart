import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weight_event.dart';
import 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightStatusState> {
  WeightBloc() : super(const WeightStatusState()) {
    on<WeightUpdated>(_onWeightUpdated);
  }

  Future<void> _onWeightUpdated(
    WeightUpdated event,
    Emitter<WeightStatusState> emit,
  ) async {
    emit(state.copyWith(
        weightEntries: [...state.weightEntries, event.weightEntry],
        weightStatus: WeightStatus.averageCalculated));
    log(state.toString());
  }
}
