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
    on<WeightEntryDeleted>(_onWeightEntryDeleted);
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
    late WeeklyWeightModel currentModel;

    if (state.weeklyWeightList.isEmpty) {
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

        updatedEntryList.sort((a, b) {
          return b.enteredOn.toString().compareTo(a.enteredOn.toString());
        });

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

    emit(state.copyWith(
      weeklyWeightList: LocalDb.restoreWeightEntryList(),
    ));

    entryDate = DateTime.now();
  }

  void _onWeightEntryDeleted(
    WeightEntryDeleted event,
    Emitter<WeightState> emit,
  ) {
    late WeeklyWeightModel currentModel;

    final matchingWeek = LocalDb.matchingWeek(
      entry: event.weightEntry,
      sundayStartDate:
          _mostRecentSunday(enteredOn: event.weightEntry.enteredOn),
    );

    if (matchingWeek!.weightEntries.length == 1) {
      LocalDb.deleteWeeklyWeightModel(id: matchingWeek.id);
      emit(state.copyWith(
        weeklyWeightList: LocalDb.restoreWeightEntryList(),
      ));
      return;
    }

    final updatedEntryList = <WeightEntry>[];

    for (final entry in matchingWeek.weightEntries) {
      if (entry != event.weightEntry) {
        updatedEntryList.add(entry);
      }
    }

    matchingWeek.weightEntries = updatedEntryList;

    currentModel = WeeklyWeightModel(
      id: matchingWeek.id,
      averageWeight: _calcAverageWeight(entryList: updatedEntryList),
      weightEntries: matchingWeek.weightEntries,
      sundayStartDate: matchingWeek.sundayStartDate,
    );

    LocalDb.storeOrUpdateModel(model: currentModel);

    emit(state.copyWith(
      weeklyWeightList: LocalDb.restoreWeightEntryList(),
    ));
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
