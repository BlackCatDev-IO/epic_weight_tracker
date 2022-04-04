import 'package:black_cat_lib/widgets/my_custom_widgets.dart';
import 'package:flutter/material.dart';

import '../../auth_bloc/auth_bloc.dart';

class ConfirmDeleteAccountDialog extends StatelessWidget {
  const ConfirmDeleteAccountDialog({Key? key, required this.authBloc})
      : super(key: key);

  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const MyTextWidget(
          text:
              'Are you sure you want to delete your account? All of your data will be deleted and this cannot be undone.',
          fontSize: 20),
      actions: [
        ElevatedButton(
          onPressed: () => authBloc.add(DeleteUser()),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
