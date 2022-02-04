import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'weight/bloc/weight_bloc.dart';
import 'weight/view/dialogs/enter_weight_dialog.dart';
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
          showDialog(
            context: context,
            builder: (BuildContext newContext) {
              return EnterWeightDialog(
                weightBloc: context.read<WeightBloc>(),
              );
            },
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
