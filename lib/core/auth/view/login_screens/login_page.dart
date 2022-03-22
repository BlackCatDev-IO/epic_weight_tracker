import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';
import '../../../../home_page.dart';
import '../../../../widgets/buttons/login_button.dart';
import '../../../../widgets/buttons/responsive_login_button.dart';
import '../../../../widgets/textfields/login_textfields.dart';
import '../../auth_bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  static const id = '/login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushNamed(context, HomePage.id);
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              EmailTextField(),
              PasswordTextField(),
              ResponsiveLoginButton(onPressed: () {}, label: 'Login'),
              Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Or continue with',
                      )
                    ],
                  ),
                ],
              ),
              LoginButtonWithIcon(
                  onPressed: () => context.read<AuthBloc>().add(GoogleSignIn()),
                  text: 'Sign in with Google',
                  iconIsImage: true,
                  imageIcon: googleIcon),
            ],
          ).paddingSymmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }
}
