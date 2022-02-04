import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/core/local_db.dart';
import 'weight_event.dart';
import 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightStatusState> {
  WeightBloc()
      : super(
          WeightStatusState(weightEntries: LocalDb.restoreWeightEntryList()),
        ) {
    on<WeightUpdateSubmitted>(_onWeightUpdated);
    on<WeightTextEntered>(_onWeightTextEntered);
  }

  double weightInput = 0;

  Future<void> _onWeightUpdated(
    WeightUpdateSubmitted event,
    Emitter<WeightStatusState> emit,
  ) async {
    final updatedList = [...state.weightEntries, event.weightEntry];
    emit(state.copyWith(
        weightEntries: updatedList,
        weightStatus: WeightStatus.averageCalculated));
    LocalDb.storeWeightEntries(updatedList: updatedList);
  }

  void _onWeightTextEntered(
    WeightTextEntered event,
    Emitter<WeightStatusState> emit,
  ) {
    weightInput = double.parse(event.input);
  }
}
