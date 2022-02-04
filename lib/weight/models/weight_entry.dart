import 'package:equatable/equatable.dart';

class WeightEntry extends Equatable {
  final double weight;
  final DateTime? enteredOn;

  const WeightEntry({required this.weight, required this.enteredOn});

  @override
  List<Object?> get props => [weight, enteredOn];
}
