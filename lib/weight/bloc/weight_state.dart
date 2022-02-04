import 'package:equatable/equatable.dart';
import 'package:weight_tracker/weight/models/weight_entry.dart';

enum WeightStatus { averageNotCalculated, averageCalculated }

class WeightStatusState extends Equatable {
  const WeightStatusState({
    this.weightStatus = WeightStatus.averageNotCalculated,
    List<WeightEntry>? weightEntries,
  }) : weightEntries = weightEntries ?? const [];

  final List<WeightEntry> weightEntries;
  final WeightStatus weightStatus;

  WeightStatusState copyWith(
      {List<WeightEntry>? weightEntries, WeightStatus? weightStatus}) {
    return WeightStatusState(
        weightEntries: weightEntries ?? this.weightEntries,
        weightStatus: weightStatus ?? this.weightStatus);
  }

  @override
  List<Object?> get props => [weightStatus, weightEntries];

  @override
  String toString() {
    final stringBuffer = StringBuffer();

    for (final entry in weightEntries) {
      final dateString = 'Entered on: ${entry.enteredOn}';
      final weight = 'Weight: ${entry.weight} ';
      stringBuffer.write('$dateString $weight');
    }

    return stringBuffer.toString();
  }
}
