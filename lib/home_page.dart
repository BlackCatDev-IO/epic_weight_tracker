import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'weight/bloc/weight_bloc.dart';
import 'weight/bloc/weight_state.dart';
import 'weight/view/dialogs/enter_weight_dialog.dart';
import 'weight/view/widgets/weekly_weight_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: _WeightEntryList(),
      ),
      floatingActionButton: const _EnterWeightButton(),
    );
  }
}

class _WeightEntryList extends StatelessWidget {
  const _WeightEntryList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightBloc, WeightState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.weeklyWeightList.length,
          itemBuilder: (context, index) {
            return WeeklyWeightWidget(model: state.weeklyWeightList[index]);
          },
        );
      },
    );
  }
}

class _EnterWeightButton extends StatelessWidget {
  const _EnterWeightButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
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
    );
  }
}
