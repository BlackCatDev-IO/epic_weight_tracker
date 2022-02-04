import 'package:equatable/equatable.dart';
import 'package:weight_tracker/weight/models/weight_entry.dart';

abstract class WeightEvent extends Equatable {
  const WeightEvent();
  @override
  List<Object?> get props => [];
}

class WeightUpdateSubmitted extends WeightEvent {
  const WeightUpdateSubmitted({required this.weightEntry});

  final WeightEntry weightEntry;

  @override
  List<Object?> get props => [weightEntry];
}

class WeightTextEntered extends WeightEvent {
  const WeightTextEntered({required this.input});

  final String input;

  @override
  List<Object?> get props => [input];
}
