import 'dart:async';
import 'dart:developer';
import 'package:black_cat_lib/extensions/num_extensions.dart';
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
    on<WeightEntrySubmitted>(_onWeightEntrySubmitted);
    on<WeightTextEntered>(_onWeightTextEntered);
    on<EntryDateModified>(_onEntryDateModified);
  }

  double weightInput = 0;
  DateTime entryDate = DateTime.now();

  void _onWeightTextEntered(
    WeightTextEntered event,
    Emitter<WeightState> emit,
  ) {
    weightInput = double.parse(event.input);
  }

  Future<void> _onWeightEntrySubmitted(
    WeightEntrySubmitted event,
    Emitter<WeightState> emit,
  ) async {
    List<WeeklyWeightModel> updatedList = [...state.weeklyWeightList];

    late WeeklyWeightModel currentModel;

    if (updatedList.isEmpty) {
      currentModel = _initAndStoreNewModel(event.weightEntry);
    } else {
      final matchingWeek = LocalDb.matchingWeek(
        entry: event.weightEntry,
        sundayStartDate:
            _mostRecentSunday(enteredOn: event.weightEntry.enteredOn),
      );

      if (matchingWeek != null) {
        final updatedEntryList = [
          ...matchingWeek.weightEntries,
          event.weightEntry
        ];

        currentModel = WeeklyWeightModel(
          id: matchingWeek.id,
          averageWeight: _calcAverageWeight(entryList: updatedEntryList),
          weightEntries: updatedEntryList,
          sundayStartDate: matchingWeek.sundayStartDate,
        );

        LocalDb.storeOrUpdateModel(model: currentModel);
      } else {
        currentModel = _initAndStoreNewModel(event.weightEntry);
      }
    }

    updatedList = LocalDb.restoreWeightEntryList();

    emit(state.copyWith(
      weeklyWeightList: updatedList,
    ));

    entryDate = DateTime.now();
  }

  WeeklyWeightModel _initAndStoreNewModel(WeightEntry entry) {
    final newModel = WeeklyWeightModel(
      averageWeight: entry.weight,
      weightEntries: [entry],
      sundayStartDate: _mostRecentSunday(enteredOn: entry.enteredOn),
    );
    LocalDb.storeOrUpdateModel(model: newModel);
    return newModel;
  }

  void _onEntryDateModified(
      EntryDateModified event, Emitter<WeightState> emit) {
    entryDate = event.modifiedDate;
    log(entryDate.toString());
  }

  DateTime _mostRecentSunday({required DateTime enteredOn}) => DateTime(
      enteredOn.year, enteredOn.month, enteredOn.day - enteredOn.weekday % 7);

  double _calcAverageWeight({required List<WeightEntry> entryList}) {
    double total = 0;

    for (final entry in entryList) {
      total += entry.weight;
    }

    final average = total / entryList.length;

    return average.toPrecision(1);
  }
}
