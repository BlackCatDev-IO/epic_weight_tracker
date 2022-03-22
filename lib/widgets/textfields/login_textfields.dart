import 'package:flutter/material.dart';

import '../general_widgets/default_textfield.dart';

class EmailTextField extends StatelessWidget {
  final textController = TextEditingController();

  EmailTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTextField(
          controller: textController,
          hintText: 'Email',
          color: Colors.white,
        ),
        Positioned(
          top: 65,
          left: 10,
          child: Text(
            textController.text,
            style: const TextStyle(color: Colors.blue, fontSize: 16.0),
          ),
        )
      ],
    );
  }
}

class PasswordTextField extends StatelessWidget {
  PasswordTextField({Key? key}) : super(key: key);
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTextField(
          controller: textController,
          hintText: 'Password',
          color: Colors.white,
          suffixIcon: ShowPasswordIcon(),
        ),
        Positioned(
          top: 65,
          left: 10,
          child: Text(
            textController.text,
            style: const TextStyle(color: Colors.blue, fontSize: 16.0),
          ),
        )
      ],
    );
  }
}

class ShowPasswordIcon extends StatelessWidget {
  ShowPasswordIcon({Key? key}) : super(key: key);

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: const Icon(Icons.remove_red_eye),
    );
  }
}
