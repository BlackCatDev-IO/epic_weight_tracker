import 'package:equatable/equatable.dart';

class WeightEntry extends Equatable {
  final double weight;
  final DateTime enteredOn;

  const WeightEntry({required this.weight, required this.enteredOn});

  Map<String, dynamic> toMap() {
    return {'weight': weight, 'enteredOn': enteredOn};
  }

  factory WeightEntry.fromMap({required Map map}) {
    return WeightEntry(weight: map['weight'], enteredOn: map['enteredOn']);
  }

  @override
  List<Object?> get props => [weight, enteredOn];
}
