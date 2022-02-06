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
    on<WeightEntrySubmitted>(_onWeightUpdated);
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

  Future<void> _onWeightUpdated(
    WeightEntrySubmitted event,
    Emitter<WeightState> emit,
  ) async {
    List<WeeklyWeightModel> updatedList = [...state.weeklyWeightList];

    if (updatedList.isEmpty) {
      updatedList = _listWithNewWeek(event, updatedList);
    } else {
      bool entryAddedToExistingWeek = false;
      for (final model in state.weeklyWeightList) {
        final isWithinWeek = _isWithinWeek(
            sundayStartDate: model.sundayStartDate,
            entryDate: event.weightEntry.enteredOn);

        if (isWithinWeek) {
          final updatedEntryList = [...model.weightEntries, event.weightEntry];
          final currentModel = WeeklyWeightModel(
            averageWeight: _calcAverageWeight(entryList: updatedEntryList),
            weightEntries: updatedEntryList,
            sundayStartDate:
                _mostRecentSunday(enteredOn: event.weightEntry.enteredOn),
          );
          final updatedIndex = updatedList.indexOf(model);

          updatedList
              .replaceRange(updatedIndex, updatedIndex + 1, [currentModel]);
          entryAddedToExistingWeek = true;
          break;
        }
      }
      if (!entryAddedToExistingWeek) {
        updatedList = _listWithNewWeek(event, updatedList);
      }
    }

    updatedList = _sortWeeklyList(updatedList);

    emit(state.copyWith(
      weeklyWeightList: updatedList,
    ));

    LocalDb.storeWeightEntries(updatedList: updatedList);
    entryDate = DateTime.now();
  }

  List<WeeklyWeightModel> _listWithNewWeek(
      WeightEntrySubmitted event, List<WeeklyWeightModel> list) {
    List<WeeklyWeightModel> newList = list;

    final currentModel = WeeklyWeightModel(
        sundayStartDate:
            _mostRecentSunday(enteredOn: event.weightEntry.enteredOn),
        weightEntries: [event.weightEntry],
        averageWeight: event.weightEntry.weight);
    newList.add(currentModel);

    return newList;
  }

  void _onEntryDateModified(
      EntryDateModified event, Emitter<WeightState> emit) {
    entryDate = event.modifiedDate;
    log(entryDate.toString());
  }

  bool _isWithinWeek(
      {required DateTime entryDate, required DateTime sundayStartDate}) {
    final endOfWeek = sundayStartDate.add(const Duration(days: 7));

    return entryDate.isAfter(sundayStartDate) && entryDate.isBefore(endOfWeek);
  }

  List<WeeklyWeightModel> _sortWeeklyList(List<WeeklyWeightModel> list) {
    List<WeeklyWeightModel> sortedList = list;
    sortedList.sort((a, b) {
      return a.sundayStartDate
          .toString()
          .compareTo(b.sundayStartDate.toString());
    });

    return sortedList;
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
