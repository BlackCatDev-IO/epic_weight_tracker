import 'package:equatable/equatable.dart';
import 'package:weight_tracker/weight/models/weekly_weight_model.dart';
import 'package:weight_tracker/weight/models/weight_entry.dart';

class WeightState extends Equatable {
  const WeightState({
    List<WeeklyWeightModel>? weeklyWeightList,
  }) : weeklyWeightList = weeklyWeightList ?? const [];

  final List<WeeklyWeightModel> weeklyWeightList;

  WeightState copyWith(
      {List<WeightEntry>? weightEntries,
      List<WeeklyWeightModel>? weeklyWeightList}) {
    return WeightState(
      weeklyWeightList: weeklyWeightList ?? this.weeklyWeightList,
    );
  }

  @override
  List<Object?> get props => [weeklyWeightList];
}
