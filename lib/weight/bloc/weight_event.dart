import 'package:equatable/equatable.dart';
import 'package:weight_tracker/weight/models/weight_entry.dart';

abstract class WeightEvent extends Equatable {
  const WeightEvent();
  @override
  List<Object?> get props => [];
}

class WeightUpdated extends WeightEvent {
  const WeightUpdated({required this.weightEntry});

  final WeightEntry weightEntry;

  @override
  List<Object?> get props => [weightEntry];
}
