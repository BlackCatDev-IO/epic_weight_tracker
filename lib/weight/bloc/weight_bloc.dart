import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weight_event.dart';
import 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightStatusState> {
  WeightBloc() : super(const WeightStatusState()) {
    on<WeightUpdateSubmitted>(_onWeightUpdated);
    on<WeightTextEntered>(_onWeightTextEntered);
  }

  double weightInput = 0;

  Future<void> _onWeightUpdated(
    WeightUpdateSubmitted event,
    Emitter<WeightStatusState> emit,
  ) async {
    emit(state.copyWith(
        weightEntries: [...state.weightEntries, event.weightEntry],
        weightStatus: WeightStatus.averageCalculated));
    log(state.toString());
  }

  void _onWeightTextEntered(
    WeightTextEntered event,
    Emitter<WeightStatusState> emit,
  ) {
    weightInput = double.parse(event.input);
  }
}
