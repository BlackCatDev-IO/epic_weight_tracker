import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';
import 'core/auth/auth_bloc/auth_bloc.dart';
import 'core/auth/view/dialogs/confirm_delete_account_dialog.dart';
import 'core/auth/view/login_screens/login_page.dart';
import 'weight/bloc/weight_bloc.dart';
import 'weight/bloc/weight_state.dart';
import 'weight/view/dialogs/enter_weight_dialog.dart';
import 'weight/view/widgets/weekly_weight_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const id = '/home_page';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          Navigator.pushNamed(context, LoginPage.id);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        drawer: const AppDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(bgImagePath), fit: BoxFit.fill),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: _WeightEntryList(),
          ),
        ),
        floatingActionButton: const _EnterWeightButton(),
      ),
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

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              context.read<AuthBloc>().add(Logout());
            },
          ),
          ListTile(
            title: const Text('Delete Account'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext newContext) {
                  return ConfirmDeleteAccountDialog(
                    authBloc: context.read<AuthBloc>(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
