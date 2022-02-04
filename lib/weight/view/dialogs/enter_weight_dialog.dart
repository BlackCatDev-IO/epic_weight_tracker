import 'package:flutter/material.dart';
import 'package:weight_tracker/weight/bloc/weight_bloc.dart';
import 'package:weight_tracker/weight/bloc/weight_event.dart';
import 'package:weight_tracker/weight/models/weight_entry.dart';

class EnterWeightDialog extends StatelessWidget {
  const EnterWeightDialog({Key? key, required this.weightBloc})
      : super(key: key);

  final WeightBloc weightBloc;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Weight'),
      actions: [
        TextField(
          onChanged: (text) => weightBloc.add(
            WeightTextEntered(input: text),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            weightBloc.add(
              WeightUpdateSubmitted(
                weightEntry: WeightEntry(
                    enteredOn: DateTime.now(), weight: weightBloc.weightInput),
              ),
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
