import 'package:black_cat_lib/black_cat_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/weight/bloc/weight_bloc.dart';
import 'package:weight_tracker/weight/bloc/weight_state.dart';
import 'package:weight_tracker/weight/models/weight_entry.dart';

class WeeklyWeightWidget extends StatelessWidget {
  const WeeklyWeightWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      width: 350,
      borderColor: Colors.black,
      child: BlocBuilder<WeightBloc, WeightStatusState>(
        builder: (context, state) {
          return Column(
            children: [
              const _Header(),
              for (final dailyEntry in state.weightEntries)
                _DailyWeightInput(weightEntry: dailyEntry),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: MyTextWidget(text: 'Week of 1/9/22'),
          ),
          Divider(
            color: Colors.black,
          )
        ],
      ),
    );
  }
}

class _DailyWeightInput extends StatelessWidget {
  final WeightEntry? weightEntry;
  const _DailyWeightInput({Key? key, required this.weightEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyTextWidget(text: weightEntry!.enteredOn.toString()),
          MyTextWidget(text: weightEntry!.weight.toString()),
        ],
      ),
    );
  }
}
