import 'package:black_cat_lib/black_cat_lib.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/weight/models/weight_entry.dart';

import '../../../utils/date_time_formatter.dart';
import '../../models/weekly_weight_model.dart';

class WeeklyWeightWidget extends StatelessWidget {
  const WeeklyWeightWidget({Key? key, required this.model}) : super(key: key);

  final WeeklyWeightModel model;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      width: 350,
      borderColor: Colors.black,
      child: Column(
        children: [
          _Header(
              startingSunday:
                  DateTimeFormatter.formatDate(model.sundayStartDate),
              averageWeight: model.averageWeight),
          const Divider(
            color: Colors.black,
          ),
          for (final dailyEntry in model.weightEntries)
            _DailyWeightInput(weightEntry: dailyEntry),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.startingSunday,
    required this.averageWeight,
  }) : super(key: key);

  final String startingSunday;
  final double averageWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyTextWidget(text: 'Week of: $startingSunday'),
              MyTextWidget(text: 'Avg: $averageWeight')
            ],
          ),
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
          MyTextWidget(
            text: DateTimeFormatter.formatDate(weightEntry!.enteredOn),
          ),
          MyTextWidget(text: weightEntry!.weight.toString()),
        ],
      ),
    );
  }
}
