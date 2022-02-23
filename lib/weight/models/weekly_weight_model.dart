import 'package:objectbox/objectbox.dart';

import 'weight_entry.dart';

@Entity()
class WeeklyWeightModel {
  WeeklyWeightModel({
    this.id = 0,
    this.weightEntries = const [],
    required this.averageWeight,
    required this.sundayStartDate,
  });

  int id;
  List<WeightEntry> weightEntries;
  final double averageWeight;
  final DateTime sundayStartDate;

  List<String> get dbWeightEntries {
    return List<String>.from(
      weightEntries.map(
        (entry) => entry.toRawJson(),
      ),
    );
  }

  set dbWeightEntries(List<String> entries) {
    weightEntries = List<WeightEntry>.from(
      entries.map(
        (e) => WeightEntry.fromRawJson(json: (e)),
      ),
    );
  }
}
