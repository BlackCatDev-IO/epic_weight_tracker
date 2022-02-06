import 'package:equatable/equatable.dart';

import 'weight_entry.dart';

class WeeklyWeightModel extends Equatable {
  final List<WeightEntry> weightEntries;
  final double averageWeight;
  final DateTime sundayStartDate;

  const WeeklyWeightModel(
      {required this.averageWeight,
      required this.weightEntries,
      required this.sundayStartDate});

  Map toMap() {
    final mapList = [];

    for (final entry in weightEntries) {
      final entryToMap = entry.toMap();
      mapList.add(entryToMap);
    }
    return {
      'weightEntries': mapList,
      'averageWeight': averageWeight,
      'sundayStartDate': sundayStartDate.toString()
    };
  }

  factory WeeklyWeightModel.fromMap({required Map map}) {
    final List entryListMaps = map['weightEntries'] ?? [];

    final entryList = <WeightEntry>[];

    if (entryListMaps.isNotEmpty) {
      for (final entryMap in entryListMaps) {
        final entry = WeightEntry(
            enteredOn: entryMap['enteredOn'] as DateTime,
            weight: entryMap['weight'] as double);
        entryList.add(entry);
      }
    }

    return WeeklyWeightModel(
      sundayStartDate: map['sundayStartDate'] == null
          ? DateTime.now()
          : DateTime.parse(map['sundayStartDate'] as String),
      weightEntries: entryList,
      averageWeight: map['averageWeight'] as double? ?? 0,
    );
  }

  @override
  List<Object?> get props => [weightEntries, averageWeight, sundayStartDate];
}
