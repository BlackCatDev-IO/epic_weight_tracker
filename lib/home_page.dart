import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'weight/bloc/weight_bloc.dart';
import 'weight/bloc/weight_event.dart';
import 'weight/models/weight_entry.dart';
import 'weight/view/widgets/weekly_weight_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: const [
            SizedBox(height: 15),
            WeeklyWeightWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<WeightBloc>().add(
                WeightUpdated(
                  weightEntry:
                      WeightEntry(weight: 200, enteredOn: DateTime.now()),
                ),
              );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 24.0,
        ),
      ),
    );
  }
}
