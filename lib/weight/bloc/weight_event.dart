import 'package:equatable/equatable.dart';
import 'package:weight_tracker/weight/models/weight_entry.dart';

abstract class WeightEvent extends Equatable {
  const WeightEvent();
  @override
  List<Object?> get props => [];
}

class WeightEntrySubmitted extends WeightEvent {
  const WeightEntrySubmitted({required this.weightEntry});

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

class EntryDateModified extends WeightEvent {
  const EntryDateModified({required this.modifiedDate});

  final DateTime modifiedDate;

  @override
  List<Object?> get props => [modifiedDate];
}
