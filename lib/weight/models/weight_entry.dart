import 'dart:convert';

import 'package:equatable/equatable.dart';

class WeightEntry extends Equatable {
  const WeightEntry({required this.weight, required this.enteredOn});

  final double weight;
  final DateTime enteredOn;

  String toRawJson() {
    return jsonEncode(
        {'weight': weight, 'enteredOn': enteredOn.toIso8601String()});
  }

  factory WeightEntry.fromRawJson({required String json}) {
    final map = jsonDecode(json);
    return WeightEntry(
      weight: map['weight'],
      enteredOn: DateTime.parse(map['enteredOn'] as String),
    );
  }

  @override
  List<Object?> get props => [weight, enteredOn];
}
