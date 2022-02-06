import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/core/local_db.dart';
import '../models/weekly_weight_model.dart';
import '../models/weight_entry.dart';
import 'weight_event.dart';
import 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  WeightBloc()
      : super(
          WeightState(weeklyWeightList: LocalDb.restoreWeightEntryList()),
        ) {
    on<WeightUpdateSubmitted>(_onWeightUpdated);
    on<WeightTextEntered>(_onWeightTextEntered);
  }

  double weightInput = 0;

  void _onWeightTextEntered(
    WeightTextEntered event,
    Emitter<WeightState> emit,
  ) {
    weightInput = double.parse(event.input);
  }

  Future<void> _onWeightUpdated(
    WeightUpdateSubmitted event,
    Emitter<WeightState> emit,
  ) async {
    List<WeeklyWeightModel> updatedList = [...state.weeklyWeightList];
    late WeeklyWeightModel currentModel;
    final sundayStartDate =
        _mostRecentSunday(enteredOn: event.weightEntry.enteredOn);

    int updatedIndex = 0;

    if (updatedList.isNotEmpty) {
      for (int i = 0; i < updatedList.length; i++) {
        final model = updatedList[i];
        final isWithinWeek = _isWithinWeek(
            sundayStartDate: model.sundayStartDate,
            entryDate: event.weightEntry.enteredOn);

        if (isWithinWeek) {
          updatedIndex = i;

          currentModel = WeeklyWeightModel(
            averageWeight: _calcAverageWeight(entryList: model.weightEntries),
            weightEntries: [...model.weightEntries, event.weightEntry],
            sundayStartDate: sundayStartDate,
          );
        }
      }
      updatedList.removeAt(updatedIndex);
      updatedList.insert(updatedIndex, currentModel);
    } else {
      currentModel = WeeklyWeightModel(
          sundayStartDate: sundayStartDate,
          weightEntries: [event.weightEntry],
          averageWeight: event.weightEntry.weight);
      updatedList.add(currentModel);
    }

    emit(state.copyWith(
      weeklyWeightList: updatedList,
    ));
    LocalDb.storeWeightEntries(updatedList: updatedList);
  }

  bool _isWithinWeek(
      {required DateTime entryDate, required DateTime sundayStartDate}) {
    final endOfWeek = sundayStartDate.add(const Duration(days: 7));

    return entryDate.isAfter(sundayStartDate) && entryDate.isBefore(endOfWeek);
  }

  DateTime _mostRecentSunday({required DateTime enteredOn}) => DateTime(
      enteredOn.year, enteredOn.month, enteredOn.day - enteredOn.weekday % 7);

  double _calcAverageWeight({required List<WeightEntry> entryList}) {
    double total = 0;

    for (final entry in entryList) {
      total += entry.weight;
    }

    return total / entryList.length;
  }
}
